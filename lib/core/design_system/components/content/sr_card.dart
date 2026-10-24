import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

enum SrCardLayout { vertical, horizontal }

enum SrCardVisualKind { none, media, icon, avatar }

/// Reusable content card matching the vertical and horizontal Figma families.
///
/// [visual] is intentionally compositional: callers can supply an image,
/// product illustration, domain icon, or avatar without coupling this design
/// system package to an image loader.
class SrCard extends StatelessWidget {
  const SrCard({
    required this.title,
    this.layout = SrCardLayout.vertical,
    this.visualKind = SrCardVisualKind.none,
    this.visual,
    this.subtitle,
    this.description,
    this.tag,
    this.metadata,
    this.action,
    this.trailing,
    this.showChevron = false,
    this.onTap,
    this.semanticLabel,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.mediaHeight = SrComponentMetrics.cardMediaHeight,
    this.horizontalMediaWidth = SrComponentMetrics.horizontalCardMediaWidth,
    this.contentPadding = const EdgeInsets.all(SrSpacing.space16),
    super.key,
  }) : assert(mediaHeight > 0),
       assert(horizontalMediaWidth > 0);

  final SrCardLayout layout;
  final SrCardVisualKind visualKind;
  final Widget? visual;
  final String title;
  final String? subtitle;
  final String? description;
  final Widget? tag;
  final Widget? metadata;
  final Widget? action;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? descriptionStyle;
  final double mediaHeight;
  final double horizontalMediaWidth;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(SrRadii.medium);
    final card = Material(
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: scheme.outlineVariant,
          width: SrComponentMetrics.borderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: layout == SrCardLayout.vertical
            ? _VerticalCardLayout(
                visualKind: visualKind,
                visual: visual,
                mediaHeight: mediaHeight,
                contentPadding: contentPadding,
                copy: _copy,
              )
            : _HorizontalCardLayout(
                visualKind: visualKind,
                visual: visual,
                mediaWidth: horizontalMediaWidth,
                contentPadding: contentPadding,
                copy: _copy,
              ),
      ),
    );

    return Semantics(
      container: true,
      label: semanticLabel ?? [title, subtitle].whereType<String>().join(', '),
      button: onTap != null,
      child: card,
    );
  }

  _CardCopy get _copy => _CardCopy(
    title: title,
    subtitle: subtitle,
    description: description,
    tag: tag,
    metadata: metadata,
    action: action,
    trailing: trailing,
    showChevron: showChevron,
    titleStyle: titleStyle,
    subtitleStyle: subtitleStyle,
    descriptionStyle: descriptionStyle,
  );
}

class _VerticalCardLayout extends StatelessWidget {
  const _VerticalCardLayout({
    required this.visualKind,
    required this.visual,
    required this.mediaHeight,
    required this.contentPadding,
    required this.copy,
  });

  final SrCardVisualKind visualKind;
  final Widget? visual;
  final double mediaHeight;
  final EdgeInsetsGeometry contentPadding;
  final Widget copy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (visualKind != SrCardVisualKind.none)
          _CardVisual(
            kind: visualKind,
            visual: visual,
            height: visualKind == SrCardVisualKind.media ? mediaHeight : null,
            vertical: true,
          ),
        Padding(padding: contentPadding, child: copy),
      ],
    );
  }
}

class _HorizontalCardLayout extends StatelessWidget {
  const _HorizontalCardLayout({
    required this.visualKind,
    required this.visual,
    required this.mediaWidth,
    required this.contentPadding,
    required this.copy,
  });

  final SrCardVisualKind visualKind;
  final Widget? visual;
  final double mediaWidth;
  final EdgeInsetsGeometry contentPadding;
  final Widget copy;

  @override
  Widget build(BuildContext context) {
    final hasVisual = visualKind != SrCardVisualKind.none;
    return Table(
      columnWidths: {
        if (hasVisual) 0: FixedColumnWidth(mediaWidth),
        hasVisual ? 1 : 0: const FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          children: [
            if (hasVisual)
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.fill,
                child: _CardVisual(kind: visualKind, visual: visual),
              ),
            Padding(padding: contentPadding, child: copy),
          ],
        ),
      ],
    );
  }
}

class _CardVisual extends StatelessWidget {
  const _CardVisual({
    required this.kind,
    required this.visual,
    this.height,
    this.vertical = false,
  });

  final SrCardVisualKind kind;
  final Widget? visual;
  final double? height;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (kind == SrCardVisualKind.media) {
      return SizedBox(
        height: height,
        child: ColoredBox(
          color: scheme.primaryContainer,
          child:
              visual ??
              Icon(
                Icons.image_outlined,
                size: SrSizing.size32,
                color: scheme.onPrimaryContainer,
              ),
        ),
      );
    }

    final child =
        visual ??
        Icon(
          kind == SrCardVisualKind.avatar
              ? Icons.person_outline_rounded
              : Icons.widgets_outlined,
          color: scheme.onPrimaryContainer,
        );
    final decorated = SizedBox.square(
      dimension: kMinInteractiveDimension,
      child: ColoredBox(
        color: scheme.primaryContainer,
        child: Center(child: child),
      ),
    );
    final compact = kind == SrCardVisualKind.avatar
        ? ClipOval(child: decorated)
        : ClipRRect(
            borderRadius: BorderRadius.circular(SrRadii.medium),
            child: decorated,
          );

    return Padding(
      padding: vertical
          ? const EdgeInsets.fromLTRB(
              SrSpacing.space16,
              SrSpacing.space24,
              SrSpacing.space16,
              0,
            )
          : EdgeInsets.zero,
      child: Align(child: compact),
    );
  }
}

class _CardCopy extends StatelessWidget {
  const _CardCopy({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tag,
    required this.metadata,
    required this.action,
    required this.trailing,
    required this.showChevron,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.descriptionStyle,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final Widget? tag;
  final Widget? metadata;
  final Widget? action;
  final Widget? trailing;
  final bool showChevron;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? descriptionStyle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolvedTrailing =
        trailing ??
        (showChevron
            ? Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant,
                semanticLabel: 'Open',
              )
            : null);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tag != null) ...[tag!, const SizedBox(height: SrSpacing.space8)],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    titleStyle ??
                    SrTypography.heading5.copyWith(color: scheme.onSurface),
              ),
            ),
            if (resolvedTrailing != null) ...[
              const SizedBox(width: SrSpacing.space8),
              resolvedTrailing,
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: SrSpacing.space4),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                subtitleStyle ??
                SrTypography.actionMedium.copyWith(color: scheme.primary),
          ),
        ],
        if (metadata != null) ...[
          const SizedBox(height: SrSpacing.space8),
          metadata!,
        ],
        if (description != null) ...[
          const SizedBox(height: SrSpacing.space8),
          Text(
            description!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style:
                descriptionStyle ??
                SrTypography.bodySmall.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
        if (action != null) ...[
          const SizedBox(height: SrSpacing.space12),
          action!,
        ],
      ],
    );
  }
}
