import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yarnie/widgets/premium_refund_dialog.dart';
import 'package:yarnie/core/providers/premium_provider.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/theme/text_styles.dart';

class YarniePremiumScreen extends ConsumerStatefulWidget {
  const YarniePremiumScreen({super.key});

  @override
  ConsumerState<YarniePremiumScreen> createState() => _YarniePremiumScreenState();
}

class _YarniePremiumScreenState extends ConsumerState<YarniePremiumScreen> {
  Package? _lifetimePackage;
  bool _isBusy = false; // 결제·복원 진행 중 (중복 탭 방지)

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current!.lifetime != null) {
        if (mounted) {
          setState(() {
            _lifetimePackage = offerings.current!.lifetime;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading offerings: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _purchase(AppLocalizations l10n) async {
    if (_isBusy) return;
    final package = _lifetimePackage;
    if (package == null) {
      // 상품 정보를 못 불러온 경우(오프라인 등): 알리고 다시 불러온다
      _showSnackBar(l10n.premiumProductUnavailable);
      _loadOfferings();
      return;
    }

    setState(() => _isBusy = true);
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      // 화면을 떠났으면 ref를 쓸 수 없다 (프리미엄 상태는 CustomerInfo 리스너가 갱신)
      if (!mounted) return;
      if (PremiumNotifier.hasPremium(purchaseResult.customerInfo)) {
        await ref.read(premiumProvider.notifier).refreshStatus();
        if (mounted) Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      _showSnackBar(switch (PurchasesErrorHelper.getErrorCode(e)) {
        PurchasesErrorCode.purchaseCancelledError => l10n.premiumPurchaseCancelled,
        PurchasesErrorCode.networkError => l10n.premiumNetworkError,
        PurchasesErrorCode.paymentPendingError => l10n.premiumPaymentPending,
        PurchasesErrorCode.productAlreadyPurchasedError => l10n.premiumAlreadyPurchased,
        _ => l10n.premiumPurchaseFailed,
      });
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _restore(AppLocalizations l10n) async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      final customerInfo = await Purchases.restorePurchases();
      if (!mounted) return;
      if (PremiumNotifier.hasPremium(customerInfo)) {
        await ref.read(premiumProvider.notifier).refreshStatus();
        _showSnackBar(l10n.premiumRestoreSuccess);
      } else {
        _showSnackBar(l10n.premiumRestoreNoHistory);
      }
    } on PlatformException catch (e) {
      _showSnackBar(PurchasesErrorHelper.getErrorCode(e) == PurchasesErrorCode.networkError
          ? l10n.premiumNetworkError
          : l10n.premiumRestoreFailed);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image with Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 256,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF637069).withValues(alpha: 0.2),
                    const Color(0xFF637069).withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: Image.asset(
                      'assets/images/premium_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.5, 1.0],
                        colors: [
                          Colors.white,
                          Colors.white.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 120),
                    const Text(
                      '🦎🧶',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 48, height: 1.0),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${l10n.premiumTitle1}\n${l10n.premiumTitle2}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleH1.copyWith(
                        color: const Color(0xFF0A0A0A),
                        height: 1.2,
                        fontSize: 30, // from Figma
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Features Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF637069).withValues(alpha: 0.2),
                          width: 0.7,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildFeatureItem(
                            title: l10n.premiumFeature1Title,
                            subtitle: l10n.premiumFeature1Sub,
                          ),
                          const SizedBox(height: 24),
                          _buildFeatureItem(
                            title: l10n.premiumFeature2Title,
                            subtitle: l10n.premiumFeature2Sub,
                          ),
                          const SizedBox(height: 24),
                          _buildFeatureItem(
                            title: l10n.premiumFeature3Title,
                            subtitle: l10n.premiumFeature3Sub,
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  width: 0.7,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFECECF0),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('🎁', style: TextStyle(fontSize: 12)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: RichText(
                                      text: TextSpan(
                                        style: AppTextStyles.bodyM.copyWith(
                                          height: 1.4,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Coming Soon: ',
                                            style: TextStyle(color: Color(0xFF637069)),
                                          ),
                                          TextSpan(
                                            // Ensure there's no duplicate text if 'Coming Soon:' exists in l10n
                                            text: l10n.premiumComingSoon.replaceAll('Coming Soon: ', '').replaceAll('Coming Soon:', ''),
                                            style: const TextStyle(color: Color(0xFF717182)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Price Card
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF637069).withValues(alpha: 0.1),
                            const Color(0xFF637069).withValues(alpha: 0.05),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF637069).withValues(alpha: 0.3),
                          width: 0.7,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _lifetimePackage?.storeProduct.priceString ?? l10n.premiumPrice,
                            style: AppTextStyles.titleH1.copyWith(
                              fontSize: 36,
                              color: const Color(0xFF0A0A0A),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTextStyles.bodyM.copyWith(
                                color: const Color(0xFF717182),
                              ),
                              children: [
                                TextSpan(text: l10n.premiumPriceDesc.split(',')[0] + ', '),
                                TextSpan(
                                  text: l10n.premiumPriceDesc.split(',').length > 1 ? l10n.premiumPriceDesc.split(',')[1].trim() : '',
                                  style: const TextStyle(color: Color(0xFF637069)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.premiumOneTime,
                            style: AppTextStyles.bodyS.copyWith(
                              color: const Color(0xFF717182),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // CTA Button
                    InkWell(
                      onTap: _isBusy ? null : () => _purchase(l10n),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF637069),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _isBusy
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                ),
                              )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/premium_bag.svg',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.premiumStartBtn,
                              style: AppTextStyles.titleH3.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.premiumBtnDesc,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyS.copyWith(
                        color: const Color(0xFF717182),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Footer Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: _isBusy ? null : () => _restore(l10n),
                          child: Text(
                            l10n.premiumRestore,
                            style: AppTextStyles.bodyM.copyWith(
                              color: const Color(0xFF637069),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: () async {
                            if (Platform.isIOS) {
                              try {
                                final refundRequestStatus = await Purchases.beginRefundRequestForActiveEntitlement();
                                if (context.mounted) {
                                  switch (refundRequestStatus) {
                                    case RefundRequestStatus.success:
                                      await ref.read(premiumProvider.notifier).refreshStatus();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(l10n.premiumRefundSuccess)),
                                        );
                                      }
                                      break;
                                    case RefundRequestStatus.userCancelled:
                                      // User cancelled, no message needed or optional snackbar
                                      break;
                                    case RefundRequestStatus.error:
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(l10n.premiumRefundFailed)),
                                      );
                                      break;
                                  }
                                }
                              } catch (e) {
                                debugPrint('Error during refund request: $e');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.premiumRefundTryAgain)),
                                  );
                                }
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => const PremiumRefundDialog(),
                              );
                            }
                          },
                          child: Text(
                            l10n.premiumRefund,
                            style: AppTextStyles.bodyM.copyWith(
                              color: const Color(0xFF637069),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final url = Uri.parse('https://sprinkle-crawdad-024.notion.site/Terms-of-Service-34408fa3261c80679ec6fab334633443?source=copy_link');
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              debugPrint('Could not launch $url');
                            }
                          },
                          child: Text(
                            l10n.premiumTerms,
                            style: AppTextStyles.bodyS.copyWith(
                              color: const Color(0xFF717182),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('·', style: TextStyle(color: Color(0xFF717182))),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () async {
                            final url = Uri.parse('https://sprinkle-crawdad-024.notion.site/Privacy-Policy-34308fa3261c8053aaa3c3b21e26d04b?source=copy_link');
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              debugPrint('Could not launch $url');
                            }
                          },
                          child: Text(
                            l10n.premiumPrivacy,
                            style: AppTextStyles.bodyS.copyWith(
                              color: const Color(0xFF717182),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      Platform.isIOS ? l10n.premiumFooterDescIOS : l10n.premiumFooterDescAndroid,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyS.copyWith(
                        color: const Color(0xFF717182),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Close button
          Positioned(
            top: MediaQuery.paddingOf(context).top + 16,
            right: 16,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                    width: 0.7,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF0A0A0A),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF637069),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/premium_check.svg',
            width: 16,
            height: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleH3.copyWith(
                  color: const Color(0xFF0A0A0A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodyM.copyWith(
                  color: const Color(0xFF717182),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
