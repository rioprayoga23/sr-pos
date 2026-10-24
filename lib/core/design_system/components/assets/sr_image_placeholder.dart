import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme_context.dart';

class SrImagePlaceholder extends StatelessWidget {
  const SrImagePlaceholder({
    this.width,
    this.height,
    this.aspectRatio = 1,
    this.icon = Icons.image_outlined,
    this.semanticLabel,
    this.borderRadius = SrRadii.medium,
    super.key,
  }) : assert(aspectRatio > 0);

  final double? width;
  final double? height;
  final double aspectRatio;
  final IconData icon;
  final String? semanticLabel;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.srColors;
    Widget placeholder = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.brandSubtle,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(icon, size: SrSizing.size32, color: colors.brandAccent),
      ),
    );

    if (height == null) {
      placeholder = AspectRatio(aspectRatio: aspectRatio, child: placeholder);
    }

    placeholder = SizedBox(width: width, height: height, child: placeholder);

    if (semanticLabel == null) {
      return ExcludeSemantics(child: placeholder);
    }

    return Semantics(
      label: semanticLabel,
      image: true,
      child: ExcludeSemantics(child: placeholder),
    );
  }
}
