import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

enum SrButtonVariant { primary, secondary, tertiary, destructive }

class SrButton extends StatelessWidget {
  const SrButton({
    required this.label,
    this.onPressed,
    this.variant = SrButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.size = SrComponentSize.medium,
    this.expand = false,
    this.semanticLabel,
    this.loadingSemanticLabel,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final SrButtonVariant variant;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isLoading;
  final SrComponentSize size;
  final bool expand;
  final String? semanticLabel;
  final String? loadingSemanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final hasAction = onPressed != null;
    final enabled = hasAction && !isLoading;
    final foregroundColor = switch (variant) {
      SrButtonVariant.primary => colors.onPrimary,
      SrButtonVariant.secondary || SrButtonVariant.tertiary => colors.primary,
      SrButtonVariant.destructive => colors.error,
    };

    final child = isLoading
        ? Semantics(
            label: loadingSemanticLabel ?? semanticLabel ?? label,
            liveRegion: true,
            child: ExcludeSemantics(
              child: SizedBox.square(
                dimension: SrSizing.size16,
                child: CircularProgressIndicator(
                  color: hasAction ? foregroundColor : theme.disabledColor,
                ),
              ),
            ),
          )
        : _ButtonContent(
            label: label,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
          );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SrRadii.small),
    );
    final minimumSize = const Size.square(kMinInteractiveDimension);
    final padding = size == SrComponentSize.small
        ? const EdgeInsets.symmetric(
            horizontal: SrComponentMetrics.smallButtonHorizontalPadding,
            vertical: SrComponentMetrics.smallButtonVerticalPadding,
          )
        : const EdgeInsets.symmetric(
            horizontal: SrSpacing.space16,
            vertical: SrSpacing.space12,
          );
    final textStyle = size == SrComponentSize.small
        ? SrTypography.actionMedium
        : SrTypography.actionLarge;
    final effectiveCallback = enabled ? onPressed : null;

    final button = switch (variant) {
      SrButtonVariant.primary => FilledButton(
        onPressed: effectiveCallback,
        focusNode: focusNode,
        autofocus: autofocus,
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.surfaceContainerHighest,
          disabledForegroundColor: theme.disabledColor,
          minimumSize: minimumSize,
          padding: padding,
          shape: shape,
          textStyle: textStyle,
        ),
        child: child,
      ),
      SrButtonVariant.secondary => OutlinedButton(
        onPressed: effectiveCallback,
        focusNode: focusNode,
        autofocus: autofocus,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          disabledForegroundColor: theme.disabledColor,
          minimumSize: minimumSize,
          padding: padding,
          side: BorderSide(
            color: enabled ? colors.primary : colors.outlineVariant,
          ),
          shape: shape,
          textStyle: textStyle,
        ),
        child: child,
      ),
      SrButtonVariant.tertiary || SrButtonVariant.destructive => TextButton(
        onPressed: effectiveCallback,
        focusNode: focusNode,
        autofocus: autofocus,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          disabledForegroundColor: theme.disabledColor,
          minimumSize: minimumSize,
          padding: padding,
          shape: shape,
          textStyle: textStyle,
        ),
        child: child,
      ),
    };

    final semanticButton = Semantics(
      label: semanticLabel,
      button: true,
      enabled: enabled,
      value: isLoading ? loadingSemanticLabel : null,
      child: button,
    );

    if (!expand) {
      return semanticButton;
    }

    return SizedBox(width: double.infinity, child: semanticButton);
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon case final icon?) ...[
          IconTheme.merge(
            data: const IconThemeData(size: SrSizing.size16),
            child: icon,
          ),
          const SizedBox(width: SrSpacing.space8),
        ],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
        if (trailingIcon case final icon?) ...[
          const SizedBox(width: SrSpacing.space8),
          IconTheme.merge(
            data: const IconThemeData(size: SrSizing.size16),
            child: icon,
          ),
        ],
      ],
    );
  }
}
