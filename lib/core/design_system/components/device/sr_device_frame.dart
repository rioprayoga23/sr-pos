import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

enum SrDeviceType { phone, tablet }

class SrDeviceFrame extends StatelessWidget {
  const SrDeviceFrame({
    required this.child,
    this.type = SrDeviceType.phone,
    this.width = SrComponentMetrics.deviceFrameWidth,
    this.showStatusBar = true,
    this.showHomeIndicator = true,
    this.statusBar,
    this.semanticLabel = 'Device preview',
    super.key,
  }) : assert(width > 0);

  final Widget child;
  final SrDeviceType type;
  final double width;
  final bool showStatusBar;
  final bool showHomeIndicator;
  final Widget? statusBar;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final phone = type == SrDeviceType.phone;
    final aspectRatio = phone
        ? SrComponentMetrics.phoneAspectRatio
        : SrComponentMetrics.tabletAspectRatio;
    final frameRadius = phone
        ? SrComponentMetrics.deviceFrameRadius
        : SrRadii.extraLarge;
    final screenRadius = phone ? SrRadii.extraLarge : SrRadii.large;

    return Semantics(
      container: true,
      label: semanticLabel,
      child: SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.inverseSurface,
              borderRadius: BorderRadius.circular(frameRadius),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.16),
                  blurRadius: SrSizing.size24,
                  offset: const Offset(0, SrSizing.size8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(SrSpacing.space8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(screenRadius),
                child: ColoredBox(
                  color: scheme.surface,
                  child: Column(
                    children: [
                      if (showStatusBar)
                        statusBar ?? SrDeviceStatusBar(showCutout: phone),
                      Expanded(child: child),
                      if (showHomeIndicator && phone)
                        const SrDeviceHomeIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SrDeviceStatusBar extends StatelessWidget {
  const SrDeviceStatusBar({
    this.timeLabel = '9:41',
    this.showCutout = true,
    super.key,
  });

  final String timeLabel;
  final bool showCutout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: 'Status bar, $timeLabel',
      child: SizedBox(
        height: SrSizing.size40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SrSpacing.space16,
              ),
              child: Row(
                children: [
                  Text(
                    timeLabel,
                    style: SrTypography.actionSmall.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.signal_cellular_alt_rounded,
                    size: SrSizing.size12,
                    color: scheme.onSurface,
                  ),
                  const SizedBox(width: SrSpacing.space4),
                  Icon(
                    Icons.wifi_rounded,
                    size: SrSizing.size12,
                    color: scheme.onSurface,
                  ),
                  const SizedBox(width: SrSpacing.space4),
                  Icon(
                    Icons.battery_full_rounded,
                    size: SrSizing.size16,
                    color: scheme.onSurface,
                  ),
                ],
              ),
            ),
            if (showCutout)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: SrSizing.size72,
                  height: SrSizing.size20,
                  decoration: BoxDecoration(
                    color: scheme.inverseSurface,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(SrRadii.medium),
                      bottomRight: Radius.circular(SrRadii.medium),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SrDeviceHomeIndicator extends StatelessWidget {
  const SrDeviceHomeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Home indicator',
      child: SizedBox(
        height: SrSizing.size24,
        child: Center(
          child: Container(
            width: SrSizing.size96,
            height: SrSizing.size4,
            decoration: BoxDecoration(
              color: scheme.onSurface,
              borderRadius: BorderRadius.circular(SrRadii.pill),
            ),
          ),
        ),
      ),
    );
  }
}
