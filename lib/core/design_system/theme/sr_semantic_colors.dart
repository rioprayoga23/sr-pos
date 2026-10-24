import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';

/// Semantic color roles consumed by SR-POS components.
///
/// Keeping these roles separate from raw palette values makes future palette
/// changes local to the theme instead of leaking them into every widget.
@immutable
final class SrSemanticColors extends ThemeExtension<SrSemanticColors> {
  const SrSemanticColors({
    required this.brand,
    required this.onBrand,
    required this.brandAccent,
    required this.brandSubtle,
    required this.onBrandSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.surface,
    required this.surfaceSubtle,
    required this.surfaceMuted,
    required this.border,
    required this.borderSubtle,
    required this.disabledSurface,
    required this.disabledForeground,
    required this.overlay,
  });

  static const SrSemanticColors light = SrSemanticColors(
    brand: SrColors.highlight900,
    onBrand: SrColors.neutralLight100,
    brandAccent: SrColors.highlight700,
    brandSubtle: SrColors.highlight100,
    onBrandSubtle: SrColors.neutralDark900,
    textPrimary: SrColors.neutralDark900,
    textSecondary: SrColors.neutralDark300,
    textMuted: SrColors.neutralDark100,
    surface: SrColors.neutralLight100,
    surfaceSubtle: SrColors.neutralLight300,
    surfaceMuted: SrColors.neutralLight500,
    border: SrColors.neutralLight900,
    borderSubtle: SrColors.neutralLight500,
    disabledSurface: SrColors.neutralLight500,
    disabledForeground: SrColors.neutralDark100,
    overlay: SrColors.neutralOverlay,
  );

  final Color brand;
  final Color onBrand;
  final Color brandAccent;
  final Color brandSubtle;
  final Color onBrandSubtle;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color surface;
  final Color surfaceSubtle;
  final Color surfaceMuted;
  final Color border;
  final Color borderSubtle;
  final Color disabledSurface;
  final Color disabledForeground;
  final Color overlay;

  @override
  SrSemanticColors copyWith({
    Color? brand,
    Color? onBrand,
    Color? brandAccent,
    Color? brandSubtle,
    Color? onBrandSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? surface,
    Color? surfaceSubtle,
    Color? surfaceMuted,
    Color? border,
    Color? borderSubtle,
    Color? disabledSurface,
    Color? disabledForeground,
    Color? overlay,
  }) {
    return SrSemanticColors(
      brand: brand ?? this.brand,
      onBrand: onBrand ?? this.onBrand,
      brandAccent: brandAccent ?? this.brandAccent,
      brandSubtle: brandSubtle ?? this.brandSubtle,
      onBrandSubtle: onBrandSubtle ?? this.onBrandSubtle,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      surface: surface ?? this.surface,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      disabledSurface: disabledSurface ?? this.disabledSurface,
      disabledForeground: disabledForeground ?? this.disabledForeground,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  SrSemanticColors lerp(covariant SrSemanticColors? other, double t) {
    if (other == null) return this;

    return SrSemanticColors(
      brand: Color.lerp(brand, other.brand, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      brandSubtle: Color.lerp(brandSubtle, other.brandSubtle, t)!,
      onBrandSubtle: Color.lerp(onBrandSubtle, other.onBrandSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      disabledSurface: Color.lerp(disabledSurface, other.disabledSurface, t)!,
      disabledForeground: Color.lerp(
        disabledForeground,
        other.disabledForeground,
        t,
      )!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}
