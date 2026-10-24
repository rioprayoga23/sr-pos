import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_borders.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme_context.dart';

enum SrAvatarSize {
  small(SrSizing.size32),
  medium(SrSizing.size40),
  large(SrSizing.size56),
  extraLarge(SrSizing.size72);

  const SrAvatarSize(this.value);

  final double value;
}

class SrAvatar extends StatelessWidget {
  const SrAvatar({
    this.image,
    this.initials,
    this.fallback,
    this.size = SrAvatarSize.medium,
    this.semanticLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    super.key,
  }) : assert(initials == null || initials.length <= 3);

  final ImageProvider<Object>? image;
  final String? initials;
  final Widget? fallback;
  final SrAvatarSize size;
  final String? semanticLabel;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.srColors;
    final dimension = size.value;
    final resolvedBackground = backgroundColor ?? colors.brandSubtle;
    final resolvedForeground = foregroundColor ?? colors.brand;
    final normalizedInitials = initials?.trim();
    final Widget fallbackContent;
    if (fallback case final customFallback?) {
      fallbackContent = customFallback;
    } else if (normalizedInitials case final avatarInitials?
        when avatarInitials.isNotEmpty) {
      fallbackContent = Text(
        avatarInitials.toUpperCase(),
        maxLines: 1,
        style: _textStyle.copyWith(color: resolvedForeground),
      );
    } else {
      fallbackContent = Icon(
        Icons.person_outline_rounded,
        size: dimension * 0.52,
        color: resolvedForeground,
      );
    }

    Widget content = ColoredBox(
      color: resolvedBackground,
      child: Center(child: fallbackContent),
    );

    if (image case final avatarImage?) {
      content = Image(
        image: avatarImage,
        width: dimension,
        height: dimension,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => ColoredBox(
          color: resolvedBackground,
          child: Center(child: fallbackContent),
        ),
      );
    }

    Widget avatar = Container(
      width: dimension,
      height: dimension,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: switch (borderColor) {
          final color? => Border.all(color: color, width: SrBorders.thin),
          null => null,
        },
      ),
      child: content,
    );

    if (semanticLabel == null) {
      return avatar;
    }

    avatar = ExcludeSemantics(child: avatar);
    return Semantics(label: semanticLabel, image: true, child: avatar);
  }

  TextStyle get _textStyle {
    return switch (size) {
      SrAvatarSize.small => SrTypography.actionSmall,
      SrAvatarSize.medium => SrTypography.actionMedium,
      SrAvatarSize.large || SrAvatarSize.extraLarge => SrTypography.actionLarge,
    };
  }
}
