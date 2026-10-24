import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/components/shared/sr_component_metrics.dart';
import 'package:sr_pos/core/design_system/foundations/sr_colors.dart';
import 'package:sr_pos/core/design_system/foundations/sr_radii.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

typedef SrDateEnabledPredicate = bool Function(DateTime date);
typedef SrMonthLabelBuilder = String Function(DateTime visibleMonth);

/// Controlled month calendar with no scheduling or persistence logic.
class SrCalendar extends StatelessWidget {
  SrCalendar({
    required this.visibleMonth,
    this.selectedDate,
    this.onDateSelected,
    this.onPreviousMonth,
    this.onNextMonth,
    this.enabledDatePredicate,
    this.monthLabelBuilder,
    List<String> weekdayLabels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    this.firstDayOfWeek = DateTime.monday,
    this.showAdjacentMonthDays = true,
    super.key,
  }) : assert(
         firstDayOfWeek >= DateTime.monday && firstDayOfWeek <= DateTime.sunday,
       ),
       assert(weekdayLabels.length == DateTime.daysPerWeek),
       weekdayLabels = List<String>.unmodifiable(weekdayLabels);

  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;
  final SrDateEnabledPredicate? enabledDatePredicate;
  final SrMonthLabelBuilder? monthLabelBuilder;
  final List<String> weekdayLabels;
  final int firstDayOfWeek;
  final bool showAdjacentMonthDays;

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final normalizedMonth = DateTime(visibleMonth.year, visibleMonth.month);
    final firstWeekdayOffset =
        (normalizedMonth.weekday - firstDayOfWeek + DateTime.daysPerWeek) %
        DateTime.daysPerWeek;
    final gridStart = normalizedMonth.subtract(
      Duration(days: firstWeekdayOffset),
    );
    final label =
        monthLabelBuilder?.call(normalizedMonth) ??
        '${_monthNames[normalizedMonth.month - 1]} ${normalizedMonth.year}';

    return Semantics(
      container: true,
      label: 'Calendar, $label',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(SrRadii.medium),
          border: Border.all(
            color: scheme.outlineVariant,
            width: SrComponentMetrics.borderWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(SrSpacing.space16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onPreviousMonth,
                    tooltip: 'Previous month',
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: SrTypography.heading4.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onNextMonth,
                    tooltip: 'Next month',
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              const SizedBox(height: SrSpacing.space8),
              Row(
                children: [
                  for (final weekday in weekdayLabels)
                    Expanded(
                      child: Center(
                        child: Text(
                          weekday,
                          style: SrTypography.captionMedium.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: SrSpacing.space8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: DateTime.daysPerWeek,
                ),
                itemCount: DateTime.daysPerWeek * 6,
                itemBuilder: (context, index) {
                  final date = gridStart.add(Duration(days: index));
                  final isInMonth = date.month == normalizedMonth.month;
                  if (!showAdjacentMonthDays && !isInMonth) {
                    return const SizedBox.shrink();
                  }
                  return _SrCalendarDay(
                    date: date,
                    isInMonth: isInMonth,
                    isSelected: DateUtils.isSameDay(date, selectedDate),
                    isToday: DateUtils.isSameDay(date, DateTime.now()),
                    isEnabled: enabledDatePredicate?.call(date) ?? true,
                    onSelected: onDateSelected,
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

class _SrCalendarDay extends StatelessWidget {
  const _SrCalendarDay({
    required this.date,
    required this.isInMonth,
    required this.isSelected,
    required this.isToday,
    required this.isEnabled,
    required this.onSelected,
  });

  final DateTime date;
  final bool isInMonth;
  final bool isSelected;
  final bool isToday;
  final bool isEnabled;
  final ValueChanged<DateTime>? onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canSelect = isEnabled && onSelected != null;
    final foreground = isSelected
        ? scheme.onPrimary
        : !isEnabled
        ? scheme.onSurface.withValues(alpha: 0.38)
        : isInMonth
        ? scheme.onSurface
        : scheme.onSurfaceVariant.withValues(alpha: 0.62);
    final shape = CircleBorder(
      side: isToday && !isSelected
          ? BorderSide(
              color: scheme.primary,
              width: SrComponentMetrics.borderWidth,
            )
          : BorderSide.none,
    );

    return Semantics(
      label: '${date.day}/${date.month}/${date.year}',
      button: canSelect,
      enabled: isEnabled,
      selected: isSelected,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(
            width: kMinInteractiveDimension,
            height: kMinInteractiveDimension,
          ),
          child: Material(
            color: isSelected ? scheme.primary : SrColors.transparent,
            shape: shape,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: canSelect ? () => onSelected!(date) : null,
              customBorder: const CircleBorder(),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: SrTypography.bodySmall.copyWith(color: foreground),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
