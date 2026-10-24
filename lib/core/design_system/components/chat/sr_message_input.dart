import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_text_styles.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';

class SrMessageInput extends StatelessWidget {
  const SrMessageInput({
    required this.controller,
    required this.onSend,
    this.focusNode,
    this.hintText = 'Message',
    this.leading,
    this.enabled = true,
    this.onChanged,
    this.semanticLabel = 'Message input',
    super.key,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final Widget? leading;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String> onSend;
  final String semanticLabel;

  void _send() {
    final message = controller.text.trim();
    if (enabled && message.isNotEmpty) onSend(message);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final valueStyle = SrComponentTextStyles.inputValue(
      context,
      enabled: enabled,
    );
    return Semantics(
      container: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(SrRadii.large),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: SrSpacing.space4,
            right: SrSpacing.space4,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (leading != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: SrSpacing.space4),
                  child: leading,
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: valueStyle,
                  enabled: enabled,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: SrComponentTextStyles.inputPlaceholder(
                      context,
                      valueStyle: valueStyle,
                    ),
                    fillColor: SrColors.transparent,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: SrSpacing.space12,
                      vertical: SrSpacing.space12,
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final canSend = enabled && controller.text.trim().isNotEmpty;
                  return IconButton(
                    onPressed: canSend ? _send : null,
                    tooltip: 'Send message',
                    color: scheme.primary,
                    icon: const Icon(Icons.send_rounded),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
