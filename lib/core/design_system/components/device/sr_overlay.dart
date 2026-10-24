import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/theme/sr_semantic_colors.dart';

class SrOverlay extends StatelessWidget {
  const SrOverlay({
    required this.child,
    required this.visible,
    this.overlayContent,
    this.alignment = Alignment.center,
    this.onDismiss,
    this.dismissLabel = 'Dismiss overlay',
    this.color,
    super.key,
  });

  final Widget child;
  final bool visible;
  final Widget? overlayContent;
  final Alignment alignment;
  final VoidCallback? onDismiss;
  final String dismissLabel;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;

    final theme = Theme.of(context);
    final semanticColors =
        theme.extension<SrSemanticColors>() ?? SrSemanticColors.light;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned.fill(
          child: ModalBarrier(
            dismissible: onDismiss != null,
            onDismiss: onDismiss,
            semanticsLabel: dismissLabel,
            color: color ?? semanticColors.overlay,
          ),
        ),
        if (overlayContent != null)
          Positioned.fill(
            child: Align(alignment: alignment, child: overlayContent),
          ),
      ],
    );
  }
}
