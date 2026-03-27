import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumNotifier extends Notifier<bool> {
  @override
  bool build() {
    _init();
    return false;
  }

  Future<void> _init() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updatePurchaseStatus(customerInfo);
    } on PlatformException catch (_) {
      // Handle error if necessary
    }

    // Listen for customer info updates
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _updatePurchaseStatus(customerInfo);
    });
  }

  void _updatePurchaseStatus(CustomerInfo customerInfo) {
    // 'premium'은 RevenueCat 대시보드에서 설정한 Entitlement ID여야 합니다.
    // 여기서는 요구사항에 따라 isPremium 상태를 관리하는 로직만 구축합니다.
    final isPremium = customerInfo.entitlements.active.containsKey('premium');
    state = isPremium;
  }

  Future<void> refreshStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      _updatePurchaseStatus(customerInfo);
    } on PlatformException catch (_) {
      // Handle error
    }
  }
}

final premiumProvider = NotifierProvider<PremiumNotifier, bool>(() {
  return PremiumNotifier();
});
