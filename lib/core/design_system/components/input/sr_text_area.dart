import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sr_pos/core/design_system/components/input/sr_input_decoration.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_text_styles.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';

/// A multiline text field styled with the SR-POS input tokens.
class SrTextArea extends StatelessWidget {
  SrTextArea({
    this.controller,
    this.initialValue,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.semanticLabel,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.size = SrComponentSize.medium,
    this.readOnly = false,
    this.autofocus = false,
    this.minLines = 4,
    this.maxLines = 6,
    this.maxLength,
    this.keyboardType = TextInputType.multiline,
    this.textInputAction = TextInputAction.newline,
    this.textCapitalization = TextCapitalization.sentences,
    Iterable<String>? autofillHints,
    List<TextInputFormatter>? inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.validator,
    super.key,
  }) : autofillHints = autofillHints == null
           ? null
           : List<String>.unmodifiable(autofillHints),
       inputFormatters = inputFormatters == null
           ? null
           : List<TextInputFormatter>.unmodifiable(inputFormatters),
       assert(
         controller == null || initialValue == null,
         'initialValue cannot be used with a controller.',
       ),
       assert(minLines > 0),
       assert(maxLines == null || maxLines >= minLines);

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? semanticLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final SrComponentSize size;
  final bool readOnly;
  final bool autofocus;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final valueStyle = SrComponentTextStyles.inputValue(
      context,
      enabled: enabled,
    );
    final field = TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      style: valueStyle,
      decoration: srInputDecoration(
        context,
        valueStyle: valueStyle,
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        size: size,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ).copyWith(alignLabelWithHint: true),
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      onTapOutside: onTapOutside,
      validator: validator,
    );

    if (semanticLabel == null) return field;

    return Semantics(label: semanticLabel, child: field);
  }
}
