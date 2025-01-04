import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/bloc/theme_bloc.dart';
import '../../core/theme/color_schemes.dart';

class GradientBackground extends StatelessWidget {
  final int pageIndex;
  final Widget child;

  const GradientBackground({
    super.key,
    required this.pageIndex,
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
        return Container(
          decoration: BoxDecoration(
            color: state.useGradientTheme ? null : Theme.of(context).colorScheme.surface,
            gradient: state.useGradientTheme
                ? LinearGradient(
                    colors: _getGradientForPage(pageIndex),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: child,
        );
      },
    );
  }
}
