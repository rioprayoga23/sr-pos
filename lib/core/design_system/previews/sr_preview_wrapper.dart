import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme.dart';

Widget srDesignSystemPreviewWrapper(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: SrTheme.light,
    home: Scaffold(body: SafeArea(child: child)),
  );
}

class SrPreviewPage extends StatelessWidget {
  const SrPreviewPage({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SrSpacing.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withSpacing(children),
      ),
    );
  }

  static List<Widget> _withSpacing(List<Widget> children) {
    return [
      for (final (index, child) in children.indexed) ...[
        if (index > 0) const SizedBox(height: SrSpacing.space16),
        child,
      ],
    ];
  }
}

class SrPreviewSection extends StatelessWidget {
  const SrPreviewSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: SrTypography.heading4),
        const SizedBox(height: SrSpacing.space8),
        child,
      ],
    );
  }
}
