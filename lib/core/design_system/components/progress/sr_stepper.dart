import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

enum SrStepStatus { completed, current, upcoming, error }

@immutable
final class SrStepperStep {
  const SrStepperStep({
    required this.label,
    required this.status,
    this.description,
  });

  final String label;
  final String? description;
  final SrStepStatus status;
}

class SrStepper extends StatelessWidget {
  SrStepper({
    required List<SrStepperStep> steps,
    this.axis = Axis.horizontal,
    this.onStepPressed,
    this.semanticLabel = 'Progress steps',
    super.key,
  }) : assert(steps.isNotEmpty),
       steps = List<SrStepperStep>.unmodifiable(steps);

  final List<SrStepperStep> steps;
  final Axis axis;
  final ValueChanged<int>? onStepPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: axis == Axis.horizontal
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < steps.length; index++)
                  Expanded(
                    child: _HorizontalStep(
                      step: steps[index],
                      index: index,
                      stepCount: steps.length,
                      previousCompleted:
                          index > 0 &&
                          steps[index - 1].status == SrStepStatus.completed,
                      onPressed: onStepPressed == null
                          ? null
                          : () => onStepPressed!(index),
                    ),
                  ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < steps.length; index++)
                  _VerticalStep(
                    step: steps[index],
                    index: index,
                    isLast: index == steps.length - 1,
                    onPressed: onStepPressed == null
                        ? null
                        : () => onStepPressed!(index),
                  ),
              ],
            ),
    );
  }
}

class _HorizontalStep extends StatelessWidget {
  const _HorizontalStep({
    required this.step,
    required this.index,
    required this.stepCount,
    required this.previousCompleted,
    required this.onPressed,
  });

  final SrStepperStep step;
  final int index;
  final int stepCount;
  final bool previousCompleted;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: kMinInteractiveDimension,
          child: Row(
            children: [
              Expanded(
                child: _StepConnector(
                  visible: index > 0,
                  completed: previousCompleted,
                ),
              ),
              _StepNode(index: index, step: step),
              Expanded(
                child: _StepConnector(
                  visible: index < stepCount - 1,
                  completed: step.status == SrStepStatus.completed,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SrSpacing.space4),
        Text(
          step.label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: SrTypography.actionSmall.copyWith(color: scheme.onSurface),
        ),
        if (step.description != null) ...[
          const SizedBox(height: SrSpacing.space2),
          Text(
            step.description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: SrTypography.bodyExtraSmall.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
    return Semantics(
      button: onPressed != null,
      selected: step.status == SrStepStatus.current,
      label: '${step.label}, ${step.status.name}',
      child: Material(
        color: SrColors.transparent,
        child: InkWell(onTap: onPressed, child: content),
      ),
    );
  }
}

class _VerticalStep extends StatelessWidget {
  const _VerticalStep({
    required this.step,
    required this.index,
    required this.isLast,
    required this.onPressed,
  });

  final SrStepperStep step;
  final int index;
  final bool isLast;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final content = Stack(
      children: [
        if (!isLast)
          PositionedDirectional(
            start:
                (kMinInteractiveDimension - SrComponentMetrics.borderWidth) / 2,
            top: kMinInteractiveDimension,
            bottom: 0,
            child: _StepConnector(
              visible: true,
              completed: step.status == SrStepStatus.completed,
              axis: Axis.vertical,
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: kMinInteractiveDimension,
              child: _StepNode(index: index, step: step),
            ),
            const SizedBox(width: SrSpacing.space12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: SrSpacing.space12,
                  bottom: SrSpacing.space24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.label,
                      style: SrTypography.actionLarge.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    if (step.description != null) ...[
                      const SizedBox(height: SrSpacing.space4),
                      Text(
                        step.description!,
                        style: SrTypography.bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
    return Semantics(
      button: onPressed != null,
      selected: step.status == SrStepStatus.current,
      label: '${step.label}, ${step.status.name}',
      child: Material(
        color: SrColors.transparent,
        child: InkWell(onTap: onPressed, child: content),
      ),
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({required this.index, required this.step});

  final int index;
  final SrStepperStep step;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isFilled = step.status != SrStepStatus.upcoming;
    final background = switch (step.status) {
      SrStepStatus.completed || SrStepStatus.current => scheme.primary,
      SrStepStatus.error => scheme.error,
      SrStepStatus.upcoming => scheme.surface,
    };
    final foreground = isFilled ? scheme.onPrimary : scheme.onSurfaceVariant;
    final border = step.status == SrStepStatus.upcoming
        ? scheme.outline
        : SrColors.transparent;
    final icon = switch (step.status) {
      SrStepStatus.completed => Icon(
        Icons.check_rounded,
        size: SrSizing.iconSmall,
        color: foreground,
      ),
      SrStepStatus.error => Icon(
        Icons.priority_high_rounded,
        size: SrSizing.iconSmall,
        color: scheme.onError,
      ),
      SrStepStatus.current || SrStepStatus.upcoming => Text(
        '${index + 1}',
        style: SrTypography.actionMedium.copyWith(color: foreground),
      ),
    };
    final node = Container(
      width: SrSizing.size32,
      height: SrSizing.size32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(
          color: border,
          width: SrComponentMetrics.borderWidth,
        ),
      ),
      child: icon,
    );

    return SizedBox.square(
      dimension: kMinInteractiveDimension,
      child: Center(child: node),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({
    required this.visible,
    required this.completed,
    this.axis = Axis.horizontal,
  });

  final bool visible;
  final bool completed;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!visible) return const SizedBox.shrink();

    return ColoredBox(
      color: completed ? scheme.primary : scheme.outlineVariant,
      child: axis == Axis.horizontal
          ? const SizedBox(height: SrComponentMetrics.borderWidth)
          : const SizedBox(width: SrComponentMetrics.borderWidth),
    );
  }
}
