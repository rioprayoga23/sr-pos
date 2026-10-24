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
  // assumption: compact density follows the Sale tablet reference while
  // retaining the shared 48 px minimum touch target.
  static const double smallInputHorizontalPadding = SrSpacing.space12;
  static const double smallInputVerticalPadding = SrSpacing.space8;
  static const double smallButtonHorizontalPadding = SrSpacing.space12;
  static const double smallButtonVerticalPadding = SrSpacing.space8;
  static const double smallListItemHorizontalPadding = SrSpacing.space12;
  static const double smallListItemVerticalPadding = SrSpacing.space4;
  static const double smallListItemMinHeight = SrSizing.minimumTouchTarget;
  static const double smallListItemLeadingSize = SrSizing.size32;
  // assumption: compact cart media nearly fills the row while leaving a
  // small bottom inset for alignment with the quantity controls.
  static const double smallCartMediaSize = SrSizing.size64;
  static const double smallCartHorizontalGap = SrSpacing.space8;
  static const double smallCartTopPadding = SrSpacing.space4;
  // assumption: keeps tablet and desktop dialogs readable without stretching.
  static const double dialogMaxWidth = SrSizing.size80 * 8;

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
