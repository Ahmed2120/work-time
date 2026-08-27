import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:work_time/core/config/app_config.dart';
import 'package:work_time/core/services/in_app_purchase_service.dart';
import 'package:work_time/core/services/service_locator.dart';

class PurchaseViewModel with ChangeNotifier {
  final InAppPurchaseService _iapService;

  PurchaseViewModel({InAppPurchaseService? iapService})
      : _iapService = iapService ?? sl<InAppPurchaseService>() {
    _init();
  }

  String _selectedTierId = AppConfig.subYearly;
  String get selectedTierId => _selectedTierId;

  String? _statusMessage;
  String? get statusMessage => _statusMessage;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  bool get isLoadingProducts => _iapService.isLoadingProducts;
  bool get isPurchasing => _iapService.isPurchasing;
  List<ProductDetails> get products => _iapService.products;
  bool get isAvailable => _iapService.isAvailable;

  void _init() {
    _iapService.initialize(
      onResult: (success, message) {
        _isSuccess = success;
        _statusMessage = message;
        notifyListeners();
      },
    );
  }

  void selectTier(String tierId) {
    _selectedTierId = tierId;
    notifyListeners();
  }

  ProductDetails? getProductForTier(String tierId) {
    try {
      return _iapService.products.firstWhere((p) => p.id == tierId);
    } catch (_) {
      return null;
    }
  }

  String getDisplayPriceForTier(SubscriptionTier tier) {
    final product = getProductForTier(tier.id);
    if (product != null && product.price.isNotEmpty) {
      return product.price;
    }
    return tier.fallbackPrice;
  }

  Future<void> buySelectedSubscription() async {
    final product = getProductForTier(_selectedTierId);
    if (product != null) {
      await _iapService.buySubscription(product);
    } else {
      // If product details not yet loaded or running in emulator without Play Store billing setup
      _statusMessage = 'جاري الاتصال بـ Google Play... يرجى المحاولة مرة أخرى.';
      await _iapService.loadProducts();
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    _statusMessage = null;
    notifyListeners();
    await _iapService.restorePurchases();
  }

  void clearStatus() {
    _statusMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _iapService.dispose();
    super.dispose();
  }
}
