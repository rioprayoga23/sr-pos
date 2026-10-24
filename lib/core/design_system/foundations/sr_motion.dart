import 'package:flutter/animation.dart';

/// A small, shared motion vocabulary for state transitions.
///
/// Motion values are implementation conventions; the source Figma file does
/// not expose authoritative timing tokens for the inspected components.
abstract final class SrMotion {
  static const Duration instant = Duration.zero;
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 200);
  static const Duration emphasized = Duration(milliseconds: 300);

  static const Curve standardCurve = Curves.easeOutCubic;
  static const Curve emphasizedCurve = Curves.easeInOutCubic;
}
