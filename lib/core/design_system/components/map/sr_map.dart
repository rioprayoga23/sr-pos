import 'package:flutter/material.dart';

import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';

@immutable
final class SrMapMarker {
  const SrMapMarker({required this.position, required this.child});

  final Alignment position;
  final Widget child;
}

class SrMap extends StatelessWidget {
  SrMap({
    required this.child,
    List<SrMapMarker> markers = const [],
    this.controls,
    this.height = SrComponentMetrics.mapMinHeight,
    this.semanticLabel = 'Map',
    super.key,
  }) : assert(height > 0),
       markers = List<SrMapMarker>.unmodifiable(markers);

  final Widget child;
  final List<SrMapMarker> markers;
  final Widget? controls;
  final double height;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SrRadii.medium),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              child,
              for (final marker in markers)
                Align(alignment: marker.position, child: marker.child),
              if (controls != null)
                PositionedDirectional(
                  top: SrSizing.size12,
                  end: SrSizing.size12,
                  child: controls!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SrMapPlaceholder extends StatelessWidget {
  SrMapPlaceholder({
    List<SrMapMarker> markers = const [],
    this.controls,
    this.height = SrComponentMetrics.mapMinHeight,
    this.semanticLabel = 'Map preview',
    super.key,
  }) : assert(height > 0),
       markers = List<SrMapMarker>.unmodifiable(markers);

  final List<SrMapMarker> markers;
  final Widget? controls;
  final double height;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SrMap(
      height: height,
      markers: markers,
      controls: controls,
      semanticLabel: semanticLabel,
      child: CustomPaint(
        painter: _MapPlaceholderPainter(
          background: scheme.surfaceContainerLow,
          road: scheme.surface,
          detail: scheme.primaryContainer,
          border: scheme.outlineVariant,
        ),
      ),
    );
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  const _MapPlaceholderPainter({
    required this.background,
    required this.road,
    required this.detail,
    required this.border,
  });

  final Color background;
  final Color road;
  final Color detail;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    final blockPaint = Paint()..color = detail;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.08,
          size.height * 0.12,
          size.width * 0.28,
          size.height * 0.24,
        ),
        const Radius.circular(SrRadii.small),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.62,
          size.height * 0.58,
          size.width * 0.3,
          size.height * 0.28,
        ),
        const Radius.circular(SrRadii.small),
      ),
      blockPaint,
    );

    final roadPaint = Paint()
      ..color = road
      ..style = PaintingStyle.stroke
      ..strokeWidth = SrSizing.size12
      ..strokeCap = StrokeCap.round;
    final borderPaint = Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = SrComponentMetrics.borderWidth;
    final roadPath = Path()
      ..moveTo(-SrSizing.size8, size.height * 0.72)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.42,
        size.width * 0.48,
        size.height * 0.76,
        size.width + SrSizing.size8,
        size.height * 0.26,
      );
    canvas.drawPath(roadPath, roadPaint);
    canvas.drawPath(roadPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _MapPlaceholderPainter oldDelegate) {
    return background != oldDelegate.background ||
        road != oldDelegate.road ||
        detail != oldDelegate.detail ||
        border != oldDelegate.border;
  }
}
