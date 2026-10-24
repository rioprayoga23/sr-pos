import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_borders.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';
import 'package:sr_pos/core/design_system/theme/sr_semantic_colors.dart';
import 'package:sr_pos/core/design_system/theme/sr_status_colors.dart';

/// Application-wide Material theme assembled from SR-POS design tokens.
abstract final class SrTheme {
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: SrColors.highlight900,
    onPrimary: SrColors.neutralLight100,
    primaryContainer: SrColors.highlight100,
    onPrimaryContainer: SrColors.neutralDark900,
    secondary: SrColors.highlight700,
    onSecondary: SrColors.neutralLight100,
    secondaryContainer: SrColors.highlight300,
    onSecondaryContainer: SrColors.neutralDark900,
    tertiary: SrColors.success700,
    onTertiary: SrColors.neutralLight100,
    tertiaryContainer: SrColors.success100,
    onTertiaryContainer: SrColors.neutralDark900,
    error: SrColors.error700,
    onError: SrColors.neutralLight100,
    errorContainer: SrColors.error100,
    onErrorContainer: SrColors.neutralDark900,
    surface: SrColors.neutralLight100,
    onSurface: SrColors.neutralDark900,
    surfaceDim: SrColors.neutralLight700,
    surfaceBright: SrColors.neutralLight100,
    surfaceContainerLowest: SrColors.neutralLight100,
    surfaceContainerLow: SrColors.neutralLight300,
    surfaceContainer: SrColors.neutralLight500,
    surfaceContainerHigh: SrColors.neutralLight700,
    surfaceContainerHighest: SrColors.neutralLight900,
    onSurfaceVariant: SrColors.neutralDark300,
    outline: SrColors.neutralLight900,
    outlineVariant: SrColors.neutralLight500,
    shadow: SrColors.neutralDark900,
    scrim: SrColors.neutralDark900,
    inverseSurface: SrColors.neutralDark900,
    onInverseSurface: SrColors.neutralLight300,
    inversePrimary: SrColors.highlight300,
    surfaceTint: SrColors.highlight900,
  );

  static ThemeData get light {
    final textTheme = SrTypography.textTheme.apply(
      bodyColor: _lightColorScheme.onSurface,
      displayColor: _lightColorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      fontFamily: SrTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: SrColors.neutralLight100,
      dividerColor: SrColors.neutralLight500,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SrColors.neutralLight300,
        hintStyle: SrTypography.bodyMedium.copyWith(
          color: SrColors.neutralDark100,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SrSpacing.space16,
          vertical: SrSpacing.space12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SrRadii.medium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SrRadii.medium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SrRadii.medium),
          borderSide: const BorderSide(
            color: SrColors.highlight900,
            width: SrBorders.focus,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SrRadii.medium),
          borderSide: const BorderSide(
            color: SrColors.error700,
            width: SrBorders.thin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SrRadii.medium),
          borderSide: const BorderSide(
            color: SrColors.error700,
            width: SrBorders.focus,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: SrColors.neutralLight500,
        thickness: SrBorders.thin,
        space: SrBorders.thin,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SrColors.highlight900,
        linearTrackColor: SrColors.neutralLight500,
        circularTrackColor: SrColors.neutralLight500,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        SrSemanticColors.light,
        SrStatusColors.light,
      ],
    );
  }
}
