import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ads/ad_manager.dart';
import '../../l10n/app_localizations.dart';

class RewardedAdDialog extends StatelessWidget {
  final VoidCallback? onUnlock;
  final VoidCallback? onCancel;

  const RewardedAdDialog({super.key, this.onUnlock, this.onCancel});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const RewardedAdDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.vibrantCyan.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_circle_outline,
                size: 40,
                color: AppColors.vibrantCyan,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.promptUnlockPremium,
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.promptWatchVideo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.btnCancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                      await adManager.showRewardedAd(
                        onReward: () {
                          onUnlock?.call();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.vibrantCyan,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.btnWatchVideo),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumContentGate extends StatefulWidget {
  final Widget lockedContent;
  final Widget unlockedContent;
  final bool isPremium;
  final String? articleId;

  const PremiumContentGate({
    super.key,
    required this.lockedContent,
    required this.unlockedContent,
    this.isPremium = false,
    this.articleId,
  });

  @override
  State<PremiumContentGate> createState() => _PremiumContentGateState();
}

class _PremiumContentGateState extends State<PremiumContentGate> {
  bool _unlocked = false;

  void _unlockContent() {
    setState(() {
      _unlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPremium || _unlocked) {
      return widget.unlockedContent;
    }

    return Column(
      children: [widget.lockedContent, _buildUnlockPrompt(context)],
    );
  }

  Widget _buildUnlockPrompt(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentPeach.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentPeach.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.lock, color: AppColors.accentPeach),
              const SizedBox(width: 12),
              Text(
                l10n.badgePremiumContent,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.promptUnlock,
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showUnlockDialog(context),
              icon: const Icon(Icons.play_circle_outline),
              label: Text(l10n.btnUnlockAd),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentPeach,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUnlockDialog(BuildContext context) async {
    final result = await RewardedAdDialog.show(context);
    if (result == true) {
      _unlockContent();
    }
  }
}
