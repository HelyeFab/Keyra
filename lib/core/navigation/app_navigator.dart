import 'package:flutter/material.dart';
import 'routes.dart';
import '../../features/books/pages/book_details_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/study/pages/study_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../features/library/pages/library_page.dart';
import '../../features/books/pages/chapter_page.dart';
import '../../features/common/pages/error_page.dart';

class AppNavigator extends StatefulWidget {
  final String initialRoute;

  const AppNavigator({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final navigator = _navigatorKey.currentState;
        if (navigator == null) return true;
        
        if (navigator.canPop()) {
          navigator.pop();
          return false;
        }
        
        return true;
      },
      child: Scaffold(
        body: Navigator(
          key: _navigatorKey,
          initialRoute: widget.initialRoute,
          onGenerateRoute: _onGenerateRoute,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Study',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    final path = uri.path;

    Widget page;
    switch (path) {
      case Routes.home:
        page = const HomePage();
        break;
      case Routes.library:
        page = const LibraryPage();
        break;
      case Routes.study:
        page = const StudyPage();
        break;
      case Routes.profile:
        page = const ProfilePage();
        break;
      case Routes.settings:
        page = const SettingsPage();
        break;
      default:
        if (path.startsWith(Routes.book)) {
          final bookId = Routes.extractBookId(path);
          if (bookId != null) {
            if (path.contains(Routes.chapter)) {
              final chapterId = Routes.extractChapterId(path);
              if (chapterId != null) {
                page = ChapterPage(bookId: bookId, chapterId: chapterId);
              } else {
                page = ErrorPage(message: 'Invalid chapter route: $path');
              }
            } else {
              page = BookDetailsPage(bookId: bookId);
            }
          } else {
            page = ErrorPage(message: 'Invalid book route: $path');
          }
        } else {
          page = ErrorPage(message: 'Route not found: $path');
        }
    }

    return MaterialPageRoute(
      builder: (context) => page,
      settings: settings,
    );
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      // Pop to first route in current tab
      _navigatorKey.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentIndex = index);
      String newRoute;
      switch (index) {
        case 0:
          newRoute = Routes.home;
          break;
        case 1:
          newRoute = Routes.library;
          break;
        case 2:
          newRoute = Routes.study;
          break;
        case 3:
          newRoute = Routes.profile;
          break;
        default:
          newRoute = Routes.home;
      }
      _navigatorKey.currentState?.pushReplacementNamed(newRoute);
    }
  }
}
