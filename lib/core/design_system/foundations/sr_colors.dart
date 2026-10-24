import 'package:flutter/material.dart';

/// Raw color primitives extracted from the SR-POS Figma reference.
///
/// Application code should prefer semantic colors from [ColorScheme] or
/// `SrStatusColors` instead of consuming these values directly.
abstract final class SrColors {
  static const Color transparent = Color(0x00000000);

  static const Color highlight900 = Color(0xFF006FFD);
  static const Color highlight700 = Color(0xFF2897FF);
  static const Color highlight500 = Color(0xFF6FBAFF);
  static const Color highlight300 = Color(0xFFB4DBFF);
  static const Color highlight100 = Color(0xFFEAF2FF);

  static const Color neutralLight900 = Color(0xFFC5C6CC);
  static const Color neutralLight700 = Color(0xFFD4D6DD);
  static const Color neutralLight500 = Color(0xFFE8E9F1);
  static const Color neutralLight300 = Color(0xFFF8F9FE);
  static const Color neutralLight100 = Color(0xFFFFFFFF);

  static const Color neutralDark900 = Color(0xFF1F2024);
  static const Color neutralDark700 = Color(0xFF2F3036);
  static const Color neutralDark500 = Color(0xFF494A50);
  static const Color neutralDark300 = Color(0xFF71727A);
  static const Color neutralDark100 = Color(0xFF8F9098);

  /// Derived scrim used behind modal surfaces.
  static const Color neutralOverlay = Color(0x991F2024);

  static const Color success700 = Color(0xFF298267);
  static const Color success500 = Color(0xFF3AC0A0);
  static const Color success100 = Color(0xFFE7F4E8);

  static const Color warning700 = Color(0xFFE86339);
  static const Color warning500 = Color(0xFFFFB37C);
  static const Color warning100 = Color(0xFFFFF4E4);

  static const Color error700 = Color(0xFFED3241);
  static const Color error500 = Color(0xFFFF616D);
  static const Color error100 = Color(0xFFFFE2E5);
}
