import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/bloc/theme_bloc.dart';
import '../../core/theme/color_schemes.dart';
import 'keyra_bottom_nav_bar.dart';

class KeyraScaffold extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigationChanged;
  final Widget child;

  const KeyraScaffold({
    super.key,
    required this.currentIndex,
    required this.onNavigationChanged,
    required this.child,
  });

  List<Color> _getGradientForPage(int index) {
    switch (index) {
      case 0:
        return AppColors.homeGradient;
      case 1:
        return AppColors.libraryGradient;
      case 2:
        return AppColors.studyGradient;
      case 3:
        return AppColors.dashboardGradient;
      case 4:
        return AppColors.profileGradient;
      default:
        return AppColors.homeGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Material(
          type: MaterialType.transparency,
          child: FocusScope(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: state.useGradientTheme ? null : Theme.of(context).colorScheme.surface,
                    gradient: state.useGradientTheme
                        ? LinearGradient(
                            colors: _getGradientForPage(currentIndex),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SafeArea(
                      bottom: false,
                      child: child,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 8,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
                            ),
                            child: KeyraBottomNavBar(
                              currentIndex: currentIndex,
                              onTap: onNavigationChanged,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
