import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  Future<void> _showTimePicker(BuildContext context, TimeOfDay initialTime) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (selectedTime != null && context.mounted) {
      context.read<NotificationBloc>().add(
            ScheduleDailyReminder(
              title: UiTranslations.of(context).translate('daily_reminder_title'),
              body: UiTranslations.of(context).translate('daily_reminder_body'),
              time: selectedTime,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(UiTranslations.of(context).translate('notifications')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(UiTranslations.of(context).translate('notifications')),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(UiTranslations.of(context).translate('ok')),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final bool isEnabled = state is NotificationPermissionGranted || 
                               state is NotificationScheduled;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text(
                    UiTranslations.of(context).translate('enable_notifications'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    UiTranslations.of(context).translate('daily_reminder_description'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                  ),
                  value: isEnabled,
                  onChanged: (value) {
                    if (value) {
                      context.read<NotificationBloc>().add(RequestNotificationPermission());
                    } else {
                      context.read<NotificationBloc>().add(CancelAllNotifications());
                    }
                  },
                ),
                if (isEnabled) ...[
                  const SizedBox(height: 24),
                  ListTile(
                    title: Text(
                      UiTranslations.of(context).translate('notification_time'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      state.notificationTime != null
                          ? state.notificationTime!.format(context)
                          : UiTranslations.of(context).translate('select_notification_time'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.access_time,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _showTimePicker(
                        context,
                        state.notificationTime ?? TimeOfDay.now(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    UiTranslations.of(context).translate('notification_info'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
