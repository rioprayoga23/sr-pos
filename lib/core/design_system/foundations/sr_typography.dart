import 'package:flutter/material.dart';

/// Typography primitives for SR-POS.
///
/// Poppins is bundled and declared in `pubspec.yaml` so every platform
/// renders the same default typeface.
abstract final class SrTypography {
  static const String fontFamily = 'Poppins';

  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle heading4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle heading5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bodyExtraLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle bodyExtraSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle actionLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle actionMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle actionSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle captionMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  /// Material typography mapping for widgets that consume [TextTheme].
  static const TextTheme textTheme = TextTheme(
    displayLarge: heading1,
    displayMedium: heading2,
    displaySmall: heading3,
    headlineLarge: heading4,
    headlineMedium: heading5,
    titleLarge: bodyExtraLarge,
    titleMedium: bodyLarge,
    titleSmall: bodyMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: actionLarge,
    labelMedium: actionMedium,
    labelSmall: actionSmall,
  );
}
