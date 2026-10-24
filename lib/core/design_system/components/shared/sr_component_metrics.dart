import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_borders.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';

/// Semantic component measurements for the Figma component families.
///
/// The reference library does not expose exact measurements for every state.
/// Keeping the few inferred values here prevents individual components from
/// accumulating unrelated magic numbers while still using the shared 4-point
/// foundation wherever possible.
abstract final class SrComponentMetrics {
  static const double borderWidth = SrBorders.thin;
  static const double progressTrackHeight = SrSizing.size8;
  static const double paginationDotSize = SrSizing.size8;
  static const double paginationActiveDotWidth = SrSizing.size24;
  static const double avatarSize = SrSizing.size32 + SrSizing.size8;
  static const double calendarCellExtent = SrSizing.size32 + SrSizing.size8;
  static const double listItemMinHeight =
      kMinInteractiveDimension + SrSpacing.space8;
  static const double cardMediaHeight = 160;
  static const double horizontalCardMediaWidth = 104;
  static const double cartMediaSize = 88;
  static const double mapMinHeight = 192;
  static const double phoneAspectRatio = 9 / 19.5;
  static const double tabletAspectRatio = 3 / 4;
  static const double deviceFrameWidth = 280;
  static const double deviceFrameRadius = SrRadii.large + SrRadii.large;
  static const double overlayOpacity = 0.48;
}
