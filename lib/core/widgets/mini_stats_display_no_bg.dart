import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../ui_language/translations/ui_translations.dart';

class MiniStatsDisplayNoBg extends StatefulWidget {
  const MiniStatsDisplayNoBg({super.key});

  @override
  State<MiniStatsDisplayNoBg> createState() => _MiniStatsDisplayNoBgState();
}

class _MiniStatsDisplayNoBgState extends State<MiniStatsDisplayNoBg> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardBloc>().loadDashboardStats();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<DashboardBloc>().loadDashboardStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (error) {
            return const SizedBox.shrink();
          },
          loaded: (booksRead, favoriteBooks, readingStreak, savedWords, isPremium, bookLimit) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatItem(
                    context,
                    Icons.book,
                    booksRead.toString(),
                    UiTranslations.of(context).translate('stats_books_read'),
                    Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    context,
                    Icons.local_fire_department,
                    readingStreak.toString(),
                    UiTranslations.of(context).translate('stats_day_streak'),
                    Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}
