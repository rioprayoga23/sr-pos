import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';

enum SrIconSize {
  small(SrSizing.iconSmall),
  medium(SrSizing.iconMedium),
  large(SrSizing.iconLarge),
  extraLarge(SrSizing.size32);

  const SrIconSize(this.value);

  final double value;
}

class SrIcon extends StatelessWidget {
  const SrIcon(
    this.icon, {
    this.size = SrIconSize.medium,
    this.color,
    this.semanticLabel,
    this.textDirection,
    super.key,
  });

  final IconData icon;
  final SrIconSize size;
  final Color? color;
  final String? semanticLabel;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size.value,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }
}
