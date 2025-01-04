import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/core/theme/bloc/theme_bloc.dart';
import 'package:Keyra/core/theme/color_schemes.dart';
import 'keyra_gradient_background.dart';

class KeyraPageBackground extends StatelessWidget {
  final Widget child;
  final String page;

  const KeyraPageBackground({
    super.key,
    required this.child,
    required this.page,
  });

  List<Color> _getGradientColors() {
    switch (page) {
      case 'home':
        return AppColors.homeGradient;
      case 'library':
        return AppColors.libraryGradient;
      case 'study':
        return AppColors.studyGradient;
      case 'dashboard':
        return AppColors.dashboardGradient;
      case 'profile':
        return AppColors.profileGradient;
      default:
        return AppColors.homeGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state.useGradientTheme) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: _getGradientColors(),
              ),
            ),
            child: child,
          );
        }

        return KeyraGradientBackground(child: child);
      },
    );
  }
}
