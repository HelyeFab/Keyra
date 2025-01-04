import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/keyra_scaffold.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
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

  final List<Widget> _pages = const [
    HomePage(),
    LibraryPage(),
    StudyPage(),
    DashboardPage(),
    ProfilePage(),
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AuthPage(),
              ),
            );
          },
          orElse: () {},
        );
      },
      child: MultiBlocProvider(
        providers: [
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
        ],
        child: KeyraScaffold(
          currentIndex: _currentIndex,
          onNavigationChanged: _onNavigationChanged,
          child: _pages[_currentIndex],
        ),
      ),
    );
  }
}
