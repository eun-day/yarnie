import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// 앱 시작 시 main()에서 미리 읽어 둔 프리미엄 여부 (RevenueCat 캐시)
final initialPremiumProvider = Provider<bool>((ref) => false);

class PremiumNotifier extends Notifier<bool> {
  AppLifecycleListener? _lifecycleListener;

  /// 'premium'은 RevenueCat 대시보드에서 설정한 Entitlement ID
  static bool hasPremium(CustomerInfo customerInfo) =>
      customerInfo.entitlements.active.containsKey('premium');

  @override
  bool build() {
    _init();
    // 상태를 다시 확인하는 동안 프리미엄 사용자에게 광고·잠금이 잠깐 보이지 않도록 미리 읽은 값으로 시작
    return ref.read(initialPremiumProvider);
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

    // 앱이 포그라운드로 돌아올 때 프리미엄 상태 갱신
    // (Android 환불 등 외부에서 권한 변경 시 즉시 반영)
    _lifecycleListener = AppLifecycleListener(
      onResume: () => refreshStatus(),
    );
  }

  void _updatePurchaseStatus(CustomerInfo customerInfo) {
    state = hasPremium(customerInfo);
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
