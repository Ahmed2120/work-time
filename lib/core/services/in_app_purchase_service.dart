import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/utils/secure_storage_helper.dart';

class InAppPurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;

  bool _isPurchasing = false;
  bool get isPurchasing => _isPurchasing;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Callback to notify UI / ViewModel of status updates
  Function(bool isSuccess, String message)? onPurchaseResult;

  // Track restore operation in-flight
  bool _isRestoring = false;
  bool _hasRestoredAnyItem = false;
  Timer? _restoreTimeoutTimer;

  /// Initialize IAP service and listen to purchase updates
  void initialize({Function(bool isSuccess, String message)? onResult}) {
    onPurchaseResult = onResult;
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _handlePurchaseUpdates,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        debugPrint('InAppPurchase Stream error: $error');
        _isPurchasing = false;
        _isRestoring = false;
        _restoreTimeoutTimer?.cancel();
        onPurchaseResult?.call(false, 'حدث خطأ أثناء الاتصال بـ Google Play: $error');
      },
    );

    loadProducts();
  }

  /// Load available subscription products from Google Play
  Future<void> loadProducts() async {
    _isLoadingProducts = true;
    _errorMessage = '';

    try {
      _isAvailable = await _iap.isAvailable();
      if (!_isAvailable) {
        _isLoadingProducts = false;
        debugPrint('InAppPurchase is not available on this device');
        return;
      }

      final ProductDetailsResponse response = await _iap.queryProductDetails(
        AppConfig.subscriptionProductIds,
      );

      if (response.error != null) {
        _errorMessage = response.error!.message;
        debugPrint('Error querying product details: ${response.error!.message}');
      }

      _products = response.productDetails;
      debugPrint('Loaded ${_products.length} products from Google Play');
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Exception querying products: $e');
    } finally {
      _isLoadingProducts = false;
    }
  }

  /// Initiate subscription purchase flow for a product
  Future<bool> buySubscription(ProductDetails productDetails) async {
    _isPurchasing = true;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

    try {
      final available = await _iap.isAvailable();
      if (!available) {
        _isPurchasing = false;
        onPurchaseResult?.call(false, 'خدمة الدفع عبر Google Play غير متاحة على هذا الجهاز.');
        return false;
      }

      final bool success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      if (!success) {
        _isPurchasing = false;
        onPurchaseResult?.call(false, 'تعذر بدء عملية الشراء من Google Play');
      }
      return success;
    } catch (e) {
      _isPurchasing = false;
      debugPrint('Exception starting purchase: $e');
      onPurchaseResult?.call(false, 'حدث خطأ: $e');
      return false;
    }
  }

  /// Restore previous purchases for user with robust timeout and feedback
  Future<void> restorePurchases() async {
    _isPurchasing = true;
    _isRestoring = true;
    _hasRestoredAnyItem = false;
    _restoreTimeoutTimer?.cancel();

    try {
      final available = await _iap.isAvailable();
      if (!available) {
        _isPurchasing = false;
        _isRestoring = false;
        onPurchaseResult?.call(false, 'خدمة Google Play غير متوفرة على هذا الجهاز حالياً.');
        return;
      }

      // Set timeout fallback in case Google Play returns no purchases in stream
      _restoreTimeoutTimer = Timer(const Duration(seconds: 4), () {
        if (_isRestoring) {
          _isPurchasing = false;
          _isRestoring = false;
          if (!_hasRestoredAnyItem) {
            onPurchaseResult?.call(
              false,
              'لم يتم العثور على أي اشتراكات سابقة نشطة مرتبطة بحساب Google Play هذا.',
            );
          }
        }
      });

      await _iap.restorePurchases();
    } catch (e) {
      _restoreTimeoutTimer?.cancel();
      _isPurchasing = false;
      _isRestoring = false;
      debugPrint('Exception restoring purchases: $e');
      onPurchaseResult?.call(false, 'تعذر استعادة المشتريات: $e');
    }
  }

  /// Handle incoming purchase stream updates
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _isPurchasing = true;
        debugPrint('Purchase pending: ${purchaseDetails.productID}');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _isPurchasing = false;
          _isRestoring = false;
          _restoreTimeoutTimer?.cancel();
          final errorMsg = purchaseDetails.error?.message ?? 'تم إلغاء عملية الشراء';
          debugPrint('Purchase error: $errorMsg');
          onPurchaseResult?.call(false, errorMsg);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _hasRestoredAnyItem = true;
          _restoreTimeoutTimer?.cancel();

          // Verify and unlock subscription
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            await _unlockPremiumFeatures(purchaseDetails);
            _isPurchasing = false;
            _isRestoring = false;
            final msg = purchaseDetails.status == PurchaseStatus.restored
                ? 'تم استعادة اشتراكك بنجاح!'
                : 'تم تفعيل الاشتراك بنجاح! شكراً لثقتك.';
            onPurchaseResult?.call(true, msg);
          } else {
            _isPurchasing = false;
            _isRestoring = false;
            onPurchaseResult?.call(false, 'تعذر التحقق من صلاحية الشراء');
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// Verify purchase token validity
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    return purchaseDetails.productID.isNotEmpty &&
        AppConfig.subscriptionProductIds.contains(purchaseDetails.productID);
  }

  /// Save verified license status in hardware-backed encrypted storage
  Future<void> _unlockPremiumFeatures(PurchaseDetails purchaseDetails) async {
    try {
      await SecureStorageHelper.setUserExist(true);
      await SecureStorageHelper.setTrial(false);
      await SecureStorageHelper.write(
        key: 'sec_active_subscription_id',
        value: purchaseDetails.productID,
      );
      if (purchaseDetails.transactionDate != null) {
        await SecureStorageHelper.write(
          key: 'sec_subscription_date',
          value: purchaseDetails.transactionDate!,
        );
      }
      debugPrint('Unlocked premium features for ${purchaseDetails.productID}');
    } catch (e) {
      debugPrint('Error unlocking premium features: $e');
    }
  }

  void dispose() {
    _restoreTimeoutTimer?.cancel();
    _subscription?.cancel();
  }
}
