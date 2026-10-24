/// Spacing primitives based on the design system's 4-point grid.
abstract final class SrSpacing {
  static const double none = 0;
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space64 = 64;

  /// Semantic aliases keep layout intent readable at call sites.
  static const double pageHorizontal = space16;
  static const double sectionGap = space24;
  static const double gridGap = space12;
}
