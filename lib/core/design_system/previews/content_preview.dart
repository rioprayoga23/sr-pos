import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sr_pos/core/design_system/components/assets/sr_avatar.dart';
import 'package:sr_pos/core/design_system/components/assets/sr_icon.dart';
import 'package:sr_pos/core/design_system/components/content/content.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/previews/sr_preview_wrapper.dart';

@Preview(
  name: 'Content',
  group: 'SR-POS Design System',
  size: Size(390, 1300),
  wrapper: srDesignSystemPreviewWrapper,
)
Widget srContentPreview() {
  return const _ContentPreview();
}

class _ContentPreview extends StatefulWidget {
  const _ContentPreview();

  @override
  State<_ContentPreview> createState() => _ContentPreviewState();
}

class _ContentPreviewState extends State<_ContentPreview> {
  var _expanded = false;
  var _selectedDate = DateTime(2026, 10, 10);

  @override
  Widget build(BuildContext context) {
    return SrPreviewPage(
      children: [
        const SrPreviewSection(
          title: 'Tag, Title, Divider, List Item',
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SrTag(label: 'New'),
              ),
              SrListTitle(title: 'Products', subtitle: 'Six items'),
              SrDivider(),
              SrListItem(
                title: 'Amazing Shoes',
                subtitle: '€ 12.00',
                leading: SrAvatar(initials: 'AS'),
                selected: true,
                showChevron: true,
              ),
              SrListItem(
                title: 'Sale',
                leading: SrIcon(Icons.point_of_sale_rounded),
                selected: true,
                selectedStyle: SrListItemSelectedStyle.primary,
                size: SrComponentSize.small,
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Accordion',
          child: SrAccordion(
            title: 'Product details',
            subtitle: 'Tap to expand',
            expanded: _expanded,
            onExpansionChanged: (value) => setState(() => _expanded = value),
            child: const Text('Comfortable everyday shoes.'),
          ),
        ),
        SrPreviewSection(
          title: 'Calendar',
          child: SrCalendar(
            visibleMonth: DateTime(2026, 10),
            selectedDate: _selectedDate,
            onDateSelected: (value) => setState(() => _selectedDate = value),
          ),
        ),
        SrPreviewSection(
          title: 'Cards',
          child: Column(
            children: [
              const SizedBox(
                width: 180,
                child: SrCard(
                  title: 'Amazing Shoes',
                  subtitle: '€ 12.00',
                  visualKind: SrCardVisualKind.media,
                  mediaHeight: 112,
                ),
              ),
              const SizedBox(height: SrSpacing.space12),
              SrCard(
                layout: SrCardLayout.horizontal,
                visualKind: SrCardVisualKind.icon,
                title: 'Daily report',
                description: 'Summary of today’s transactions.',
                showChevron: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
