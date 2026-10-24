import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';

/// Theme-aware separator for lists and grouped content.
class SrDivider extends StatelessWidget {
  const SrDivider({
    this.axis = Axis.horizontal,
    this.indent = 0,
    this.endIndent = 0,
    super.key,
  });

  final Axis axis;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;
    if (axis == Axis.vertical) {
      return VerticalDivider(
        width: SrComponentMetrics.borderWidth,
        thickness: SrComponentMetrics.borderWidth,
        indent: indent,
        endIndent: endIndent,
        color: color,
      );
    }
    return Divider(
      height: SrComponentMetrics.borderWidth,
      thickness: SrComponentMetrics.borderWidth,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
