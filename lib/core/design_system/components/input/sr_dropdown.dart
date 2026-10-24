import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/input/sr_input_decoration.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_text_styles.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';

@immutable
final class SrDropdownItem<T> {
  const SrDropdownItem({
    required this.value,
    required this.label,
    this.leading,
    this.enabled = true,
  });

  final T value;
  final String label;
  final Widget? leading;
  final bool enabled;
}

/// A controlled dropdown using immutable [SrDropdownItem] options.
class SrDropdown<T> extends StatefulWidget {
  SrDropdown({
    required List<SrDropdownItem<T>> items,
    required this.onChanged,
    this.value,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.semanticLabel,
    this.prefixIcon,
    this.size = SrComponentSize.medium,
    this.enabled = true,
    this.autofocus = false,
    this.menuMaxHeight,
    super.key,
  }) : items = List<SrDropdownItem<T>>.unmodifiable(items),
       assert(items.isNotEmpty);

  final List<SrDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? semanticLabel;
  final Widget? prefixIcon;
  final SrComponentSize size;
  final bool enabled;
  final bool autofocus;
  final double? menuMaxHeight;

  @override
  State<SrDropdown<T>> createState() => _SrDropdownState<T>();
}

class _SrDropdownState<T> extends State<SrDropdown<T>> {
  late FocusNode _focusNode;
  late bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _setFocusNode(widget.focusNode);
  }

  @override
  void didUpdateWidget(covariant SrDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) return;

    _focusNode.removeListener(_handleFocusChanged);
    if (_ownsFocusNode) _focusNode.dispose();
    _setFocusNode(widget.focusNode);
  }

  void _setFocusNode(FocusNode? externalFocusNode) {
    _ownsFocusNode = externalFocusNode == null;
    _focusNode = externalFocusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  void _handleFocusChanged() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.value == null ||
          widget.items.where((item) => item.value == widget.value).length == 1,
      'value must match exactly one dropdown item.',
    );

    final enabled = widget.enabled && widget.onChanged != null;
    final valueStyle = SrComponentTextStyles.inputValue(
      context,
      enabled: enabled,
    );
    final selectedItem = widget.value == null
        ? null
        : widget.items.firstWhere((item) => item.value == widget.value);

    final dropdown = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
      child: InputDecorator(
        isEmpty: selectedItem == null,
        isFocused: _focusNode.hasFocus,
        decoration: srInputDecoration(
          context,
          valueStyle: valueStyle,
          labelText: widget.labelText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          size: widget.size,
          prefixIcon: widget.prefixIcon,
        ).copyWith(enabled: enabled),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: widget.value,
            isExpanded: true,
            isDense: true,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            menuMaxHeight: widget.menuMaxHeight,
            style: valueStyle,
            hint: switch (widget.hintText) {
              final hintText? => Text(
                hintText,
                style: SrComponentTextStyles.inputPlaceholder(
                  context,
                  valueStyle: valueStyle,
                ),
              ),
              null => null,
            },
            onChanged: enabled ? widget.onChanged : null,
            items: widget.items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item.value,
                    enabled: item.enabled,
                    child: _DropdownItemContent(item: item),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ),
    );

    return Semantics(
      label: widget.semanticLabel ?? widget.labelText,
      value: selectedItem?.label,
      enabled: enabled,
      child: dropdown,
    );
  }
}

class _DropdownItemContent<T> extends StatelessWidget {
  const _DropdownItemContent({required this.item});

  final SrDropdownItem<T> item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (item.leading case final leading?) ...[
          leading,
          const SizedBox(width: SrSizing.size8),
        ],
        Expanded(
          child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
