import 'package:flutter/material.dart';

/// App-wide spacing constants. This contains standard spacings and paddings
/// to maintain consistency throughout the app.
abstract class AppSpacing {
  /// Padding and margin values
  static const double none = 0;
  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  /// Border radius values
  static const double radiusNone = 0;
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusXxl = 32;
  static const double radiusCircular = 999;

  /// Standard edge insets
  static const EdgeInsets paddingNone = EdgeInsets.zero;
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  /// Horizontal edge insets
  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  /// Vertical edge insets
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);

  /// Box shadow values
  static List<BoxShadow> shadowSm(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> shadowMd(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> shadowLg(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.1),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];
}
