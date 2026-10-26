import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/assets/sr_icon.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_text_styles.dart';
import 'package:sr_pos/core/design_system/foundations/sr_borders.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme_context.dart';

/// An accessible file selection surface with optional image or filename preview.
///
/// File access and persistence are supplied by the caller through [onPressed].
class SrFilePicker extends StatefulWidget {
  const SrFilePicker({
    required this.onPressed,
    this.image,
    this.fileName,
    this.icon = Icons.attach_file_rounded,
    this.title = 'Unggah berkas',
    this.supportingText = 'Pilih berkas dari perangkat',
    this.replacementText = 'Ketuk untuk mengganti berkas',
    this.semanticLabel,
    this.height = SrSizing.size80 + SrSizing.size96,
    super.key,
  });

  final VoidCallback? onPressed;
  final ImageProvider<Object>? image;
  final String? fileName;
  final IconData icon;
  final String title;
  final String supportingText;
  final String replacementText;
  final String? semanticLabel;
  final double height;

  @override
  State<SrFilePicker> createState() => _SrFilePickerState();
}

/// Compatibility alias for callers that still use the original image-only name.
@Deprecated('Use SrFilePicker for image or file selection.')
typedef SrImageUpload = SrFilePicker;

class _SrFilePickerState extends State<SrFilePicker> {
  var _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final semanticColors = context.srColors;
    final isEnabled = widget.onPressed != null;
    final borderRadius = BorderRadius.circular(SrRadii.small);
    final labelColor = isEnabled
        ? colors.onSurface
        : semanticColors.disabledForeground;
    final borderColor = _isFocused ? colors.primary : colors.outlineVariant;
    final borderWidth = _isFocused ? SrBorders.focus : SrBorders.thin;
    final selectedFile = widget.fileName;
    final title = selectedFile ?? widget.title;
    final supportingText = selectedFile == null
        ? widget.supportingText
        : widget.replacementText;

    return Semantics(
      label: widget.semanticLabel ?? selectedFile ?? widget.title,
      button: true,
      enabled: isEnabled,
      image: widget.image != null,
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: Material(
          color: colors.surface,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: widget.onPressed,
            onFocusChange: (isFocused) {
              if (_isFocused == isFocused) return;
              setState(() => _isFocused = isFocused);
            },
            borderRadius: borderRadius,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.image case final image?)
                    Image(
                      image: image,
                      fit: BoxFit.cover,
                      excludeFromSemantics: true,
                      errorBuilder: (_, _, _) => ColoredBox(
                        color: colors.surfaceContainerLow,
                        child: _FilePickerContent(
                          title: title,
                          supportingText: supportingText,
                          icon: widget.icon,
                          labelColor: labelColor,
                          iconColor: isEnabled
                              ? colors.primary
                              : semanticColors.disabledForeground,
                          iconSurfaceColor: isEnabled
                              ? colors.primaryContainer
                              : colors.surfaceContainerLow,
                        ),
                      ),
                    )
                  else
                    ColoredBox(
                      color: colors.surface,
                      child: _FilePickerContent(
                        title: title,
                        supportingText: supportingText,
                        icon: selectedFile == null
                            ? widget.icon
                            : Icons.insert_drive_file_outlined,
                        labelColor: labelColor,
                        iconColor: isEnabled
                            ? colors.primary
                            : semanticColors.disabledForeground,
                        iconSurfaceColor: isEnabled
                            ? colors.primaryContainer
                            : colors.surfaceContainerLow,
                      ),
                    ),
                  if (widget.image != null)
                    ColoredBox(
                      color: semanticColors.overlay,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SrIcon(
                              widget.icon,
                              size: SrIconSize.large,
                              color: colors.onInverseSurface,
                            ),
                            const SizedBox(height: SrSpacing.space8),
                            Text(
                              widget.replacementText,
                              style: SrComponentTextStyles.inputValue(
                                context,
                                enabled: true,
                              ).copyWith(color: colors.onInverseSurface),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _DashedBorderPainter(
                          color: borderColor,
                          strokeWidth: borderWidth,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilePickerContent extends StatelessWidget {
  const _FilePickerContent({
    required this.title,
    required this.supportingText,
    required this.icon,
    required this.labelColor,
    required this.iconColor,
    required this.iconSurfaceColor,
  });

  final String title;
  final String supportingText;
  final IconData icon;
  final Color labelColor;
  final Color iconColor;
  final Color iconSurfaceColor;

  @override
  Widget build(BuildContext context) {
    final valueStyle = SrComponentTextStyles.inputValue(context, enabled: true);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SrSpacing.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: SrSizing.size56,
              height: SrSizing.size56,
              decoration: BoxDecoration(
                color: iconSurfaceColor,
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: SrBorders.thin),
              ),
              child: Center(
                child: SrIcon(icon, size: SrIconSize.large, color: iconColor),
              ),
            ),
            const SizedBox(height: SrSpacing.space12),
            Text(
              title,
              style: valueStyle.copyWith(color: labelColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: SrSpacing.space4),
            Text(
              supportingText,
              style: valueStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final borderPath = Path()
      ..addRRect(
        BorderRadius.circular(SrRadii.small).toRRect(
          Rect.fromLTWH(
            inset,
            inset,
            size.width - strokeWidth,
            size.height - strokeWidth,
          ),
        ),
      );
    final dashedPath = Path();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in borderPath.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final dashEnd = math.min(distance + SrSpacing.space8, metric.length);
        dashedPath.addPath(metric.extractPath(distance, dashEnd), Offset.zero);
        distance = dashEnd + SrSpacing.space4;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
  }
}
