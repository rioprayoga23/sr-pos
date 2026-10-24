import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_sizing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

@immutable
final class SrNavBarAction {
  const SrNavBarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.semanticLabel,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final String? semanticLabel;
}

/// A top navigation bar with optional back affordance and typed actions.
class SrNavBar extends StatelessWidget implements PreferredSizeWidget {
  SrNavBar({
    this.title,
    this.titleWidget,
    List<SrNavBarAction> titleActions = const [],
    this.titleTrailing,
    this.leading,
    this.onBack,
    List<SrNavBarAction> actions = const [],
    this.bottom,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticLabel,
    super.key,
  }) : titleActions = List<SrNavBarAction>.unmodifiable(titleActions),
       actions = List<SrNavBarAction>.unmodifiable(actions),
       assert(
         title == null || titleWidget == null,
         'Use either title or titleWidget, not both.',
       );

  final String? title;
  final Widget? titleWidget;

  /// Icon actions placed inline after the title.
  final List<SrNavBarAction> titleActions;

  /// Optional content placed after [titleActions].
  final Widget? titleTrailing;
  final Widget? leading;
  final VoidCallback? onBack;
  final List<SrNavBarAction> actions;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? semanticLabel;

  @override
  Size get preferredSize =>
      Size.fromHeight(SrSizing.size56 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final resolvedForeground = foregroundColor ?? colors.onSurface;
    final titleContent =
        titleWidget ??
        switch (title) {
          final title? => Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          null => null,
        };
    final resolvedTitle = titleActions.isEmpty && titleTrailing == null
        ? titleContent
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (titleContent != null)
                Flexible(fit: FlexFit.loose, child: titleContent),
              for (final action in titleActions) _buildAction(action),
              if (titleTrailing != null)
                Flexible(fit: FlexFit.loose, child: titleTrailing!),
            ],
          );
    final resolvedLeading =
        leading ??
        (onBack == null
            ? null
            : IconButton(
                onPressed: onBack,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const Icon(Icons.arrow_back_rounded),
              ));

    return Semantics(
      label: semanticLabel,
      container: true,
      header: true,
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: resolvedLeading,
        title: resolvedTitle,
        centerTitle: centerTitle,
        backgroundColor: backgroundColor ?? colors.surface,
        foregroundColor: resolvedForeground,
        surfaceTintColor: SrColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: SrTypography.heading3.copyWith(
          color: resolvedForeground,
        ),
        actions: actions.map(_buildAction).toList(growable: false),
        bottom: bottom,
      ),
    );
  }

  Widget _buildAction(SrNavBarAction action) {
    return Semantics(
      label: action.semanticLabel,
      button: true,
      enabled: action.onPressed != null,
      child: IconButton(
        onPressed: action.onPressed,
        tooltip: action.tooltip,
        icon: action.icon,
      ),
    );
  }
}
