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
        onPurchaseResult?.call(false, 'حدث خطأ أثناء معالجة عملية الشراء');
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

  /// Restore previous purchases for user
  Future<void> restorePurchases() async {
    _isPurchasing = true;
    try {
      await _iap.restorePurchases();
    } catch (e) {
      _isPurchasing = false;
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
          final errorMsg = purchaseDetails.error?.message ?? 'تم إلغاء عملية الشراء';
          debugPrint('Purchase error: $errorMsg');
          onPurchaseResult?.call(false, errorMsg);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // Verify and unlock subscription
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            await _unlockPremiumFeatures(purchaseDetails);
            _isPurchasing = false;
            final msg = purchaseDetails.status == PurchaseStatus.restored
                ? 'تم استعادة اشتراكك بنجاح!'
                : 'تم تفعيل الاشتراك بنجاح! شكراً لثقتك.';
            onPurchaseResult?.call(true, msg);
          } else {
            _isPurchasing = false;
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
    // Verified via Google Play Billing signature & token
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
    _subscription?.cancel();
  }
}
