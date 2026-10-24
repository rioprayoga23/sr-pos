import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';
import 'package:sr_pos/core/design_system/theme/sr_semantic_colors.dart';
import 'package:sr_pos/core/design_system/theme/sr_status_colors.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme.dart';

void main() {
  test('palette preserves the extracted Figma values', () {
    expect(SrColors.highlight900, const Color(0xFF006FFD));
    expect(SrColors.highlight100, const Color(0xFFEAF2FF));
    expect(SrColors.neutralLight300, const Color(0xFFF8F9FE));
    expect(SrColors.neutralDark900, const Color(0xFF1F2024));
    expect(SrColors.success700, const Color(0xFF298267));
    expect(SrColors.warning700, const Color(0xFFE86339));
    expect(SrColors.error700, const Color(0xFFED3241));
  });

  test('typography preserves the roles with the product typeface', () {
    expect(SrTypography.heading1.fontFamily, 'Poppins');
    expect(SrTypography.heading1.fontSize, 24);
    expect(SrTypography.heading1.fontWeight, FontWeight.w800);
    expect(SrTypography.bodyMedium.fontSize, 14);
    expect(SrTypography.bodyMedium.fontWeight, FontWeight.w400);
    expect(SrTypography.actionLarge.fontSize, 14);
    expect(SrTypography.actionLarge.fontWeight, FontWeight.w600);
  });

  test('light theme registers semantic design-system extensions', () {
    final theme = SrTheme.light;

    expect(theme.textTheme.bodyMedium?.fontFamily, 'Poppins');
    expect(theme.scaffoldBackgroundColor, SrColors.neutralLight100);
    expect(theme.extension<SrSemanticColors>(), SrSemanticColors.light);
    expect(theme.extension<SrStatusColors>(), SrStatusColors.light);
  });
}
