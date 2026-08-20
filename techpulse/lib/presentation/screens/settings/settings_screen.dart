import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/api_constants.dart';
import '../../../services/notification_service/notification_service.dart';
import 'package:techpulse/l10n/app_localizations.dart';

const String _privacyPolicyUrl = 'https://techpulse.app/privacy';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const String _notificationsEnabledKey = 'notifications_enabled';

  bool _notificationsEnabled = true;
  bool _updatingNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationsPreference();
  }

  Future<void> _loadNotificationsPreference() async {
    final box = await Hive.openBox(AppConstants.settingsBox);
    final stored = box.get(_notificationsEnabledKey);
    if (mounted) {
      setState(() {
        _notificationsEnabled = stored is bool ? stored : true;
      });
    }
  }

  Future<void> _toggleNotifications(bool enabled) async {
    setState(() => _updatingNotifications = true);
    try {
      if (enabled) {
        await notificationServiceProvider.requestPermission();
        final token = await notificationServiceProvider.getDeviceToken();
        if (token != null) {
          await notificationServiceProvider.registerDeviceToken(token);
        }
      } else {
        final token = await notificationServiceProvider.getDeviceToken();
        if (token != null) {
          await notificationServiceProvider.unregisterDeviceToken(token);
        }
      }
      final box = await Hive.openBox(AppConstants.settingsBox);
      await box.put(_notificationsEnabledKey, enabled);
      if (mounted) {
        setState(() => _notificationsEnabled = enabled);
      }
    } finally {
      if (mounted) {
        setState(() => _updatingNotifications = false);
      }
    }
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final uri = Uri.tryParse(_privacyPolicyUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                AppLocalizations.of(context)!.navSettings,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.sectionAppearance,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.06,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.vibrantCyan.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            color: AppColors.vibrantCyan,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.labelDarkMode,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                isDark ? AppLocalizations.of(context)!.labelCurrentlyDark : AppLocalizations.of(context)!.labelCurrentlyLight,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            ref
                                .read(themeModeProvider.notifier)
                                .setThemeMode(
                                  value ? ThemeMode.dark : ThemeMode.light,
                                );
                          },
                          activeColor: AppColors.vibrantCyan,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.sectionLanguage,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.06,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Locale>(
                        value: locale,
                        isExpanded: true,
                        icon: Icon(
                          Icons.language,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: Locale('am'),
                            child: Text('አማርኛ'),
                          ),
                        ],
                        onChanged: (locale) {
                          if (locale != null) {
                            ref.read(localeProvider.notifier).setLocale(locale);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.sectionNotifications,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.06,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.vibrantCyan.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: AppColors.vibrantCyan,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .labelPushNotifications,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .labelNotificationsSubtitle,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _notificationsEnabled,
                          onChanged: _updatingNotifications
                              ? null
                              : _toggleNotifications,
                          activeColor: AppColors.vibrantCyan,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.sectionAbout,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.06,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          context,
                          icon: Icons.info_outline,
                          title: AppLocalizations.of(context)!.labelVersion,
                          subtitle: AppLocalizations.of(context)!.version,
                        ),
                        Divider(
                          color: isDark
                              ? AppColors.dividerDark
                              : AppColors.dividerLight,
                        ),
                        _buildSettingItem(
                          context,
                          icon: Icons.code,
                          title: AppLocalizations.of(context)!.labelDeveloper,
                          subtitle: 'ZenaTech Team',
                        ),
                        Divider(
                          color: isDark
                              ? AppColors.dividerDark
                              : AppColors.dividerLight,
                        ),
                        _buildSettingItem(
                          context,
                          icon: Icons.privacy_tip_outlined,
                          title: AppLocalizations.of(context)!.labelPrivacyPolicy,
                          onTap: () => _openPrivacyPolicy(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 16,
                ),
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
          ],
        ),
      ),
    );
  }
}
