import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

enum SrMessageDirection { incoming, outgoing }

class SrMessageBubble extends StatelessWidget {
  const SrMessageBubble({
    required this.message,
    required this.direction,
    this.sender,
    this.timestamp,
    this.avatar,
    this.status,
    this.semanticLabel,
    super.key,
  });

  final String message;
  final SrMessageDirection direction;
  final String? sender;
  final String? timestamp;
  final Widget? avatar;
  final Widget? status;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final outgoing = direction == SrMessageDirection.outgoing;
    final background = outgoing ? scheme.primary : scheme.surfaceContainerLow;
    final foreground = outgoing ? scheme.onPrimary : scheme.onSurface;
    final secondary = outgoing
        ? scheme.onPrimary.withValues(alpha: 0.78)
        : scheme.onSurfaceVariant;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(SrRadii.medium),
      topRight: const Radius.circular(SrRadii.medium),
      bottomLeft: Radius.circular(
        outgoing ? SrRadii.medium : SrRadii.extraSmall,
      ),
      bottomRight: Radius.circular(
        outgoing ? SrRadii.extraSmall : SrRadii.medium,
      ),
    );

    return Semantics(
      container: true,
      label:
          semanticLabel ??
          [sender, message, timestamp].whereType<String>().join(', '),
      child: Align(
        alignment: outgoing ? Alignment.centerRight : Alignment.centerLeft,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : 400.0;
            final maxBubbleWidth = math.min(availableWidth * 0.78, 320.0);
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              textDirection: outgoing ? TextDirection.rtl : TextDirection.ltr,
              children: [
                if (avatar != null) ...[
                  SizedBox.square(
                    dimension: SrSizing.size32,
                    child: ClipOval(child: avatar),
                  ),
                  const SizedBox(width: SrSpacing.space8),
                ],
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: radius,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SrSpacing.space12,
                          vertical: SrSpacing.space8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (sender != null) ...[
                              Text(
                                sender!,
                                style: SrTypography.actionSmall.copyWith(
                                  color: secondary,
                                ),
                              ),
                              const SizedBox(height: SrSpacing.space4),
                            ],
                            Text(
                              message,
                              style: SrTypography.bodyMedium.copyWith(
                                color: foreground,
                              ),
                            ),
                            if (timestamp != null || status != null) ...[
                              const SizedBox(height: SrSpacing.space4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (timestamp != null)
                                    Text(
                                      timestamp!,
                                      style: SrTypography.bodyExtraSmall
                                          .copyWith(color: secondary),
                                    ),
                                  if (status != null) ...[
                                    const SizedBox(width: SrSpacing.space4),
                                    IconTheme(
                                      data: IconThemeData(
                                        color: secondary,
                                        size: SrSizing.size16,
                                      ),
                                      child: status!,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
