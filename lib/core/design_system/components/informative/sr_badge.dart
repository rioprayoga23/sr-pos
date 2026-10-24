import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/informative/sr_feedback_tone.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

class SrBadge extends StatelessWidget {
  const SrBadge({
    required this.label,
    this.tone = SrFeedbackTone.info,
    this.child,
    this.alignment = Alignment.topRight,
    this.offset = Offset.zero,
    this.semanticLabel,
    super.key,
  }) : _shape = _SrBadgeShape.pill;

  const SrBadge.dot({
    this.tone = SrFeedbackTone.info,
    this.child,
    this.alignment = Alignment.topRight,
    this.offset = Offset.zero,
    this.semanticLabel,
    super.key,
  }) : label = null,
       _shape = _SrBadgeShape.dot;

  const SrBadge._count({
    required this.label,
    required this.tone,
    required this.child,
    required this.alignment,
    required this.offset,
    required this.semanticLabel,
    super.key,
  }) : _shape = _SrBadgeShape.count;

  factory SrBadge.count({
    required int count,
    int maximum = 99,
    SrFeedbackTone tone = SrFeedbackTone.info,
    Widget? child,
    Alignment alignment = Alignment.topRight,
    Offset offset = Offset.zero,
    String? semanticLabel,
    Key? key,
  }) {
    assert(count >= 0);
    assert(maximum > 0);
    return SrBadge._count(
      label: count > maximum ? '$maximum+' : '$count',
      tone: tone,
      alignment: alignment,
      offset: offset,
      semanticLabel: semanticLabel,
      key: key,
      child: child,
    );
  }

  final String? label;
  final SrFeedbackTone tone;
  final Widget? child;
  final Alignment alignment;
  final Offset offset;
  final String? semanticLabel;
  final _SrBadgeShape _shape;

  bool get isDot => _shape == _SrBadgeShape.dot;

  @override
  Widget build(BuildContext context) {
    final palette = tone.resolve(context);
    final badge = Semantics(
      label: semanticLabel ?? label,
      child: ExcludeSemantics(
        child: _BadgeBody(shape: _shape, label: label, palette: palette),
      ),
    );

    if (child case final decoratedChild?) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          decoratedChild,
          Positioned.fill(
            child: Align(
              alignment: alignment,
              child: Transform.translate(offset: offset, child: badge),
            ),
          ),
        ],
      );
    }

    return badge;
  }
}

enum _SrBadgeShape { pill, dot, count }

class _BadgeBody extends StatelessWidget {
  const _BadgeBody({
    required this.shape,
    required this.label,
    required this.palette,
  });

  final _SrBadgeShape shape;
  final String? label;
  final SrFeedbackPalette palette;

  @override
  Widget build(BuildContext context) {
    if (shape == _SrBadgeShape.dot) {
      return SizedBox.square(
        dimension: SrSizing.size8,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: palette.solid,
            shape: const CircleBorder(),
          ),
        ),
      );
    }

    final text = Text(
      label ?? '',
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: SrTypography.captionMedium.copyWith(color: palette.onSolid),
    );
    final isSingleDigitCount =
        shape == _SrBadgeShape.count && (label?.length ?? 0) == 1;

    if (isSingleDigitCount) {
      return SizedBox.square(
        dimension: SrSizing.size24,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: palette.solid,
            shape: const CircleBorder(),
          ),
          child: Center(child: text),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.solid,
        borderRadius: BorderRadius.circular(SrRadii.pill),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: SrSizing.size24,
          minHeight: SrSizing.size24,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SrSpacing.space8),
          child: Center(widthFactor: 1, heightFactor: 1, child: text),
        ),
      ),
    );
  }
}
