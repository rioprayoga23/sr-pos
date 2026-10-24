import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_text_styles.dart';
import 'package:sr_pos/core/design_system/components/sr_component_size.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';

/// The empty, focused, and filled search field from the SR-POS reference.
class SrSearchBar extends StatefulWidget {
  const SrSearchBar({
    this.controller,
    this.initialValue,
    this.focusNode,
    this.placeholder = 'Search',
    this.semanticLabel,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.size = SrComponentSize.medium,
    this.readOnly = false,
    this.autofocus = false,
    this.showClearButton = true,
    this.clearButtonTooltip = 'Clear search',
    this.textInputAction = TextInputAction.search,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
    this.onTap,
    this.onTapOutside,
    super.key,
  }) : assert(
         controller == null || initialValue == null,
         'initialValue cannot be used with a controller.',
       );

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String placeholder;
  final String? semanticLabel;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final SrComponentSize size;
  final bool readOnly;
  final bool autofocus;
  final bool showClearButton;
  final String clearButtonTooltip;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onCleared;
  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutside;

  @override
  State<SrSearchBar> createState() => _SrSearchBarState();
}

class _SrSearchBarState extends State<SrSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late bool _ownsController;
  late bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _setController(widget.controller);
    _setFocusNode(widget.focusNode);
  }

  @override
  void didUpdateWidget(covariant SrSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleTextChanged);
      if (_ownsController) _controller.dispose();
      _setController(widget.controller);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      if (_ownsFocusNode) _focusNode.dispose();
      _setFocusNode(widget.focusNode);
    }
  }

  void _setController(TextEditingController? externalController) {
    _ownsController = externalController == null;
    _controller =
        externalController ??
        TextEditingController(text: widget.initialValue ?? '');
    _controller.addListener(_handleTextChanged);
  }

  void _setFocusNode(FocusNode? externalFocusNode) {
    _ownsFocusNode = externalFocusNode == null;
    _focusNode = externalFocusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  void _handleTextChanged() => setState(() {});

  void _handleFocusChanged() => setState(() {});

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onCleared?.call();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleFocusChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final canClear =
        widget.enabled &&
        !widget.readOnly &&
        widget.showClearButton &&
        _controller.text.isNotEmpty;
    final suffix =
        widget.trailing ??
        (canClear
            ? IconButton(
                onPressed: _clear,
                tooltip: widget.clearButtonTooltip,
                icon: const Icon(Icons.close_rounded),
              )
            : null);
    final contentPadding = widget.size == SrComponentSize.small
        ? const EdgeInsets.symmetric(
            horizontal: SrComponentMetrics.smallInputHorizontalPadding,
            vertical: SrComponentMetrics.smallInputVerticalPadding,
          )
        : const EdgeInsets.symmetric(
            horizontal: SrSpacing.space16,
            vertical: SrSpacing.space12,
          );
    final valueStyle = SrComponentTextStyles.inputValue(
      context,
      enabled: widget.enabled,
    );

    final field = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: valueStyle,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        onTapOutside: widget.onTapOutside,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: SrComponentTextStyles.inputPlaceholder(
            context,
            valueStyle: valueStyle,
          ),
          prefixIcon: ExcludeSemantics(
            child: IconTheme.merge(
              data: const IconThemeData(size: SrSizing.iconMedium),
              child: widget.leading ?? const Icon(Icons.search_rounded),
            ),
          ),
          suffixIcon: suffix,
          filled: true,
          fillColor: colors.surfaceContainerLow,
          contentPadding: contentPadding,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(SrRadii.medium)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(SrRadii.medium)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(SrRadii.medium)),
            borderSide: BorderSide.none,
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(SrRadii.medium)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );

    return Semantics(
      label: widget.semanticLabel ?? widget.placeholder,
      textField: true,
      enabled: widget.enabled,
      child: field,
    );
  }
}
