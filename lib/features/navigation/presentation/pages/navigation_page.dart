import 'package:flutter/material.dart';
import 'package:Keyra/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/keyra_scaffold.dart';
import '../../../../core/ui_language/bloc/ui_language_bloc.dart';
import '../../../../core/presentation/bloc/language_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../subscription/presentation/bloc/subscription_bloc.dart';
import '../../../subscription/presentation/bloc/subscription_event.dart';
import '../../../subscription/presentation/bloc/subscription_state.dart';
import '../../../subscription/data/repositories/subscription_repository.dart';
import '../../../subscription/domain/entities/subscription_enums.dart' show SubscriptionStatus, SubscriptionTier;
import '../../../auth/presentation/pages/auth_page.dart';
import '../../../study/presentation/pages/study_page.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/data/repositories/user_stats_repository.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../library/presentation/pages/library_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../badges/presentation/bloc/badge_bloc.dart';
import '../../../badges/data/repositories/badge_repository_impl.dart';
import '../../../dictionary/data/repositories/saved_words_repository.dart';

class NavigationPage extends StatefulWidget {
  final int? initialIndex;
  const NavigationPage({super.key, this.initialIndex});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 0;
  }

  List<Widget> get _pages => [
    const HomePage(),
    const LibraryPage(),
    const StudyPage(),
    const DashboardPage(),
    const ProfilePage(),
  ];

  void _onNavigationChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          unauthenticated: () {
            // Silently navigate to auth page without showing error message
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: context.read<UiLanguageBloc>(),
                    ),
                    BlocProvider.value(
                      value: context.read<LanguageBloc>(),
                    ),
                    BlocProvider.value(
                      value: context.read<AuthBloc>(),
                    ),
                  ],
                  child: const AuthPage(),
                ),
              ),
              (route) => false, // Remove all previous routes from the stack
            );
          },
          orElse: () {},
        );
      },
      child: MultiProvider(
        providers: [
          Provider<SavedWordsRepository>(
            create: (_) => SavedWordsRepository(),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
              userStatsRepository: UserStatsRepository(),
            ),
          ),
          BlocProvider<BadgeBloc>(
            create: (context) => BadgeBloc(
              badgeRepository: BadgeRepositoryImpl(),
              savedWordsRepository: SavedWordsRepository(),
              userStatsRepository: UserStatsRepository(),
            ),
          ),
          BlocProvider.value(
            value: context.read<UiLanguageBloc>(),
          ),
          BlocProvider.value(
            value: context.read<LanguageBloc>(),
          ),
          BlocProvider<SubscriptionBloc>(
            create: (context) => SubscriptionBloc(
              subscriptionRepository: SubscriptionRepository(),
            )..add(const SubscriptionEvent.started()),
          ),
        ],
        child: BlocListener<SubscriptionBloc, SubscriptionState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (subscription) {
                final bool isActive = subscription.status == SubscriptionStatus.active && 
                    subscription.endDate.isAfter(DateTime.now());
                final String tierStatus = subscription.tier == SubscriptionTier.premium ? 'PREMIUM' : 'FREE';
                final String activeStatus = isActive ? 'ACTIVE' : 'INACTIVE';
                
                Logger.log('Current User Subscription Status: ${subscription.tier == SubscriptionTier.premium ? "PREMIUM" : "FREE"}');
              },
              orElse: () {},
            );
          },
          child: KeyraScaffold(
            currentIndex: _currentIndex,
            onNavigationChanged: _onNavigationChanged,
            child: _pages[_currentIndex],
          ),
        ),
      ),
    );
  }
}
