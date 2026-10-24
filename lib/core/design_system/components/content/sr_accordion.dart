import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

/// Controlled disclosure component. The parent owns [expanded].
class SrAccordion extends StatelessWidget {
  const SrAccordion({
    required this.title,
    required this.expanded,
    required this.child,
    this.subtitle,
    this.leading,
    this.onExpansionChanged,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool expanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      button: true,
      enabled: onExpansionChanged != null,
      expanded: expanded,
      label: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: SrColors.transparent,
            child: InkWell(
              onTap: onExpansionChanged == null
                  ? null
                  : () => onExpansionChanged!(!expanded),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: kMinInteractiveDimension,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SrSpacing.space16,
                    vertical: SrSpacing.space12,
                  ),
                  child: Row(
                    children: [
                      if (leading != null) ...[
                        IconTheme(
                          data: IconThemeData(color: scheme.onSurfaceVariant),
                          child: leading!,
                        ),
                        const SizedBox(width: SrSpacing.space12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: SrTypography.actionLarge.copyWith(
                                color: scheme.onSurface,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: SrSpacing.space4),
                              Text(
                                subtitle!,
                                style: SrTypography.bodySmall.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: SrSpacing.space12),
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                SrSpacing.space16,
                0,
                SrSpacing.space16,
                SrSpacing.space16,
              ),
              child: child,
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}
