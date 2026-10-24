import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/sr_component_size.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

@immutable
final class SrContentSwitcherItem<T> {
  const SrContentSwitcherItem({
    required this.value,
    required this.label,
    this.icon,
    this.semanticLabel,
  });

  final T value;
  final String label;
  final Widget? icon;
  final String? semanticLabel;
}

class SrContentSwitcher<T> extends StatelessWidget {
  const SrContentSwitcher({
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.semanticLabel,
    this.size = SrComponentSize.medium,
    super.key,
  }) : assert(items.length >= 2 && items.length <= 4);

  final Iterable<SrContentSwitcherItem<T>> items;
  final T selectedValue;
  final ValueChanged<T>? onChanged;
  final String? semanticLabel;
  final SrComponentSize size;

  @override
  Widget build(BuildContext context) {
    assert(
      items.any((item) => item.value == selectedValue),
      'selectedValue must match one SrContentSwitcherItem.',
    );

    final colors = Theme.of(context).colorScheme;
    final callback = onChanged;

    return Semantics(
      label: semanticLabel,
      container: true,
      child: Material(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(SrRadii.medium),
        child: Padding(
          padding: const EdgeInsets.all(SrSpacing.space4),
          child: Row(
            children: items
                .map((item) {
                  final selected = item.value == selectedValue;
                  final foreground = selected
                      ? colors.onSurface
                      : colors.onSurfaceVariant;

                  return Expanded(
                    child: Semantics(
                      label: item.semanticLabel ?? item.label,
                      button: true,
                      selected: selected,
                      enabled: callback != null,
                      inMutuallyExclusiveGroup: true,
                      child: ExcludeSemantics(
                        child: Material(
                          color: selected
                              ? colors.surface
                              : colors.surfaceContainer,
                          borderRadius: BorderRadius.circular(SrRadii.small),
                          child: InkWell(
                            onTap: callback == null
                                ? null
                                : () => callback(item.value),
                            borderRadius: BorderRadius.circular(SrRadii.small),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: kMinInteractiveDimension,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SrSpacing.space8,
                                  vertical: size == SrComponentSize.small
                                      ? SrSpacing.space8
                                      : SrSpacing.space12,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item.icon case final icon?) ...[
                                      IconTheme.merge(
                                        data: IconThemeData(
                                          color: foreground,
                                          size: SrSizing.size16,
                                        ),
                                        child: icon,
                                      ),
                                      const SizedBox(width: SrSpacing.space8),
                                    ],
                                    Flexible(
                                      child: Text(
                                        item.label,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: SrTypography.actionMedium
                                            .copyWith(color: foreground),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}
