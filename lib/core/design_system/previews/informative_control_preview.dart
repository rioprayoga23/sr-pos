import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sr_pos/core/design_system/components/assets/assets.dart';
import 'package:sr_pos/core/design_system/components/control/control.dart';
import 'package:sr_pos/core/design_system/components/informative/informative.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';
import 'package:sr_pos/core/design_system/previews/sr_preview_wrapper.dart';

@Preview(
  name: 'Informative and Control',
  group: 'SR-POS Design System',
  size: Size(390, 1200),
  wrapper: srDesignSystemPreviewWrapper,
)
Widget srInformativeControlPreview() {
  return const _InformativeControlPreview();
}

class _InformativeControlPreview extends StatefulWidget {
  const _InformativeControlPreview();

  @override
  State<_InformativeControlPreview> createState() =>
      _InformativeControlPreviewState();
}

class _InformativeControlPreviewState
    extends State<_InformativeControlPreview> {
  String _period = 'Daily';
  var _tabIndex = 0;
  var _filterSelected = true;

  @override
  Widget build(BuildContext context) {
    final supportingTextStyle = SrTypography.bodyMedium.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return SrPreviewPage(
      children: [
        SrPreviewSection(
          title: 'Banner and Toast',
          child: Column(
            children: [
              const SrBanner(
                title: 'Order saved',
                message: 'The transaction is ready to continue.',
                tone: SrFeedbackTone.success,
              ),
              const SizedBox(height: SrSpacing.space8),
              SrToast(
                message: 'Connection restored',
                tone: SrFeedbackTone.info,
                actionLabel: 'View',
                onAction: () {},
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Badge and Tooltip',
          child: Row(
            children: [
              SrBadge.count(
                count: 2,
                child: Icon(Icons.notifications_outlined),
              ),
              const SizedBox(width: SrSpacing.space24),
              const SrTooltip(
                message: 'More information',
                child: Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Buttons',
          child: Wrap(
            spacing: SrSpacing.space8,
            runSpacing: SrSpacing.space8,
            children: [
              SrButton(label: 'Primary', onPressed: () {}),
              SrButton(
                label: 'Compact',
                size: SrComponentSize.small,
                onPressed: () {},
              ),
              SrButton(
                label: 'Secondary',
                variant: SrButtonVariant.secondary,
                onPressed: () {},
              ),
              SrButton(
                label: 'Tertiary',
                variant: SrButtonVariant.tertiary,
                onPressed: () {},
              ),
              SrButton(
                label: 'Hapus',
                leadingIcon: SrIcon(
                  Icons.delete_outline_rounded,
                  size: SrIconSize.small,
                ),
                variant: SrButtonVariant.destructive,
                size: SrComponentSize.small,
                onPressed: () {},
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Content Switcher',
          child: SrContentSwitcher<String>(
            items: const [
              SrContentSwitcherItem(value: 'Daily', label: 'Daily'),
              SrContentSwitcherItem(value: 'Weekly', label: 'Weekly'),
              SrContentSwitcherItem(value: 'Monthly', label: 'Monthly'),
            ],
            selectedValue: _period,
            onChanged: (value) => setState(() => _period = value),
          ),
        ),
        SrPreviewSection(
          title: 'Filter and Tabs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SrFilter(
                label: 'Filter',
                leading: const Icon(Icons.tune_rounded),
                trailing: SrBadge.count(count: 2),
                selected: _filterSelected,
                onSelected: (value) => setState(() => _filterSelected = value),
              ),
              const SizedBox(height: SrSpacing.space12),
              SrTabs(
                items: const [
                  SrTabItem(label: 'Overview'),
                  SrTabItem(label: 'Activity'),
                ],
                selectedIndex: _tabIndex,
                onChanged: (value) => setState(() => _tabIndex = value),
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Action Sheet',
          child: SrActionSheet(
            title: 'Product action',
            actions: [
              SrActionSheetItem(
                label: 'Duplicate',
                leading: const Icon(Icons.copy_outlined),
                onPressed: () {},
              ),
              SrActionSheetItem(
                label: 'Delete',
                leading: const Icon(Icons.delete_outline_rounded),
                tone: SrActionSheetItemTone.destructive,
                onPressed: () {},
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Dialog',
          child: SrDialog(
            title: 'Remove item?',
            onClose: () {},
            actions: [
              SrDialogAction(
                label: 'Cancel',
                variant: SrButtonVariant.secondary,
                onPressed: () {},
              ),
              SrDialogAction(label: 'Remove', onPressed: () {}),
            ],
            children: [
              Text(
                'This action cannot be undone.',
                textAlign: TextAlign.center,
                style: supportingTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
