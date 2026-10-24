import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme_context.dart';

class SrVideoPlaceholder extends StatelessWidget {
  const SrVideoPlaceholder({
    this.onPlay,
    this.width,
    this.height,
    this.aspectRatio = 16 / 9,
    this.semanticLabel,
    this.playSemanticLabel,
    this.borderRadius = SrRadii.medium,
    super.key,
  }) : assert(aspectRatio > 0),
       assert(onPlay == null || playSemanticLabel != null);

  final VoidCallback? onPlay;
  final double? width;
  final double? height;
  final double aspectRatio;
  final String? semanticLabel;
  final String? playSemanticLabel;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.srColors;
    Widget video = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Semantics(
          label: playSemanticLabel,
          button: onPlay != null,
          enabled: onPlay != null,
          child: ExcludeSemantics(
            child: Material(
              color: colors.surface,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onPlay,
                customBorder: const CircleBorder(),
                child: SizedBox.square(
                  dimension: SrSizing.size48,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: colors.brand,
                    size: SrSizing.size32,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (height == null) {
      video = AspectRatio(aspectRatio: aspectRatio, child: video);
    }

    video = SizedBox(width: width, height: height, child: video);

    if (semanticLabel == null) {
      return video;
    }

    return Semantics(
      label: semanticLabel,
      image: true,
      container: true,
      child: video,
    );
  }
}
