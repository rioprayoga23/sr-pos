import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

class SrLocationPin extends StatelessWidget {
  const SrLocationPin({
    this.label,
    this.icon,
    this.selected = false,
    this.onPressed,
    this.semanticLabel,
    super.key,
  });

  final String? label;
  final Widget? icon;
  final bool selected;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.error;
    final marker = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTheme(
          data: IconThemeData(color: color, size: SrSizing.size40),
          child: icon ?? const Icon(Icons.location_on_rounded),
        ),
        if (label != null) ...[
          const SizedBox(height: SrSpacing.space2),
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(SrRadii.extraSmall),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.12),
                  blurRadius: SrSizing.size8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SrSpacing.space8,
                vertical: SrSpacing.space4,
              ),
              child: Text(
                label!,
                style: SrTypography.actionSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ],
    );

    return Semantics(
      label: semanticLabel ?? label ?? 'Location',
      button: onPressed != null,
      selected: selected,
      child: onPressed == null
          ? marker
          : Material(
              color: SrColors.transparent,
              child: InkResponse(
                onTap: onPressed,
                radius: kMinInteractiveDimension / 2,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: kMinInteractiveDimension,
                    minHeight: kMinInteractiveDimension,
                  ),
                  child: marker,
                ),
              ),
            ),
    );
  }
}
