import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/keyra_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../navigation/presentation/pages/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/color_schemes.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/ui_language/bloc/ui_language_bloc.dart';
import '../../../../core/ui_language/widgets/ui_language_selector_modal.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../subscription/presentation/widgets/subscription_badge.dart';
import '../../../notifications/services/notification_service.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/pages/notification_settings_page.dart';
import 'acknowledgments_page.dart';
import 'terms_of_service_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.maybeWhen(
          authenticated: (_) {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              // If we're authenticated but have no user, something went wrong
              context.read<AuthBloc>().add(const AuthBlocEvent.signOutRequested());
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading profile. Please sign in again.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'If this persists, try clearing your app data.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              );
            }
            return _buildProfileContent(context, user);
          },
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Color _getIconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.icon
        : AppColors.iconDark;
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(UiTranslations.of(context).translate('logout')),
          content: Text(UiTranslations.of(context).translate('logout_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(UiTranslations.of(context).translate('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(UiTranslations.of(context).translate('logout')),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      context.read<AuthBloc>().add(const AuthBlocEvent.signOutRequested());
    }
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    final theme = Theme.of(context);
    final iconColor = _getIconColor(context);

    return KeyraScaffold(
      currentIndex: 4,
      onNavigationChanged: (index) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => NavigationPage(initialIndex: index),
          ),
          (route) => false,
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SubscriptionBadge(),
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedLogout01,
                    color: iconColor,
                    size: 24.0,
                  ),
                  onPressed: () => _showLogoutConfirmation(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3,
                              ),
                            ),
                            child: Container(
                              width: 94,
                              height: 94,
                              decoration: user.photoURL == null
                                ? BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                                    ),
                                  )
                                : null,
                              child: CircleAvatar(
                                radius: 47,
                                backgroundColor: Colors.transparent,
                                backgroundImage: user.photoURL != null
                                    ? NetworkImage(user.photoURL!)
                                    : null,
                                child: user.photoURL == null
                                    ? Text(
                                        user.email?.substring(0, 1).toUpperCase() ?? 'U',
                                        style: theme.textTheme.headlineMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.displayName ?? user.email ?? 'User',
                            style: theme.textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (user.email != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              user.email!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Settings Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              UiTranslations.of(context).translate('settings'),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AppColors.sectionTitle,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          BlocBuilder<ThemeBloc, ThemeState>(
                            builder: (context, themeState) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: HugeIcon(
                                      icon: HugeIcons.strokeRoundedMoon,
                                      color: iconColor,
                                      size: 24.0,
                                    ),
                                    title: Text(
                                      UiTranslations.of(context).translate('theme_mode'),
                                    ),
                                    subtitle: Text(
                                      themeState.themeMode == ThemeMode.system
                                          ? UiTranslations.of(context).translate('system_theme')
                                          : themeState.themeMode == ThemeMode.dark
                                              ? UiTranslations.of(context).translate('dark_theme')
                                              : UiTranslations.of(context).translate('light_theme'),
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        themeState.themeMode == ThemeMode.system
                                            ? Icons.brightness_auto
                                            : themeState.themeMode == ThemeMode.dark
                                                ? Icons.dark_mode
                                                : Icons.light_mode,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                      onPressed: () => context.read<ThemeBloc>().add(const ThemeEvent.toggleTheme()),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedNotificationBubble,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('notifications'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            onTap: () {
                              final prefs = context.read<SharedPreferences>();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => NotificationBloc(
                                      notificationService: NotificationService(),
                                    )..add(RequestNotificationPermission()),
                                    child: const NotificationSettingsPage(),
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedTranslate,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('app_language'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            onTap: () => _showLanguageDialog(context),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Information Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              UiTranslations.of(context).translate('information'),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AppColors.sectionTitle,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedClipboard,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('version'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            trailing: Text(
                              '1.0.0',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                            ),
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedStar,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('acknowledgments'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: context.read<UiLanguageBloc>(),
                                    child: const AcknowledgmentsPage(),
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedKnightShield,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('privacy_policy'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            onTap: () async {
                              try {
                                final url = Uri.parse('https://keyrastories.com/privacy');
                                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          UiTranslations.of(context).translate('error_opening_url'),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        UiTranslations.of(context).translate('error_opening_url'),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedBook03,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('terms_of_service'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: context.read<UiLanguageBloc>(),
                                    child: const TermsOfServicePage(),
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedCode,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('developer'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            subtitle: Text(
                              UiTranslations.of(context).translate('developer_name'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                            ),
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedMessage01,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('contact_us'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            onTap: () async {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'keyra-reader@gmail.com',
                                queryParameters: {
                                  'subject': 'Keyra App Feedback',
                                },
                              );
                              try {
                                if (!await launchUrl(emailLaunchUri)) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          UiTranslations.of(context).translate('error_opening_url'),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        UiTranslations.of(context).translate('error_opening_url'),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Socials Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              UiTranslations.of(context).translate('socials'),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AppColors.sectionTitle,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedTelegram,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('chat_with_friends'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            subtitle: Text(
                              UiTranslations.of(context).translate('improve_language_skills'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            onTap: () async {
                              const url = 'https://t.me/keyra_community';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              }
                            },
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedInstagram,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('instagram'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            subtitle: Text(
                              UiTranslations.of(context).translate('discover_learning_tips'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            onTap: () async {
                              const url = 'https://instagram.com/keyra_reader';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              }
                            },
                          ),
                          ListTile(
                            leading: HugeIcon(
                              icon: HugeIcons.strokeRoundedTiktok,
                              color: iconColor,
                              size: 24.0,
                            ),
                            title: Text(
                              UiTranslations.of(context).translate('tiktok'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            subtitle: Text(
                              UiTranslations.of(context).translate('fun_language_content'),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              const url = 'https://tiktok.com/@keyra_reader';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<UiLanguageBloc>(),
        child: const UiLanguageSelectorModal(),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }
}
