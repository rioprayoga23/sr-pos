import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sr_pos/core/design_system/components/input/sr_input_decoration.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_text_styles.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';

/// A single-line text field styled with the SR-POS input tokens.
class SrTextField extends StatelessWidget {
  SrTextField({
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
    this.obscureText = false,
    this.autofocus = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    Iterable<String>? autofillHints,
    List<TextInputFormatter>? inputFormatters,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
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
       );

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
  final bool obscureText;
  final bool autofocus;
  final bool enableSuggestions;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
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
      ),
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      autofocus: autofocus,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLines: 1,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      onTapOutside: onTapOutside,
      validator: validator,
    );

    if (semanticLabel == null) return field;

    return Semantics(label: semanticLabel, child: field);
  }
}
