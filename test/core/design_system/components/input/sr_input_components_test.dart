import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/input/input.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  group('selection inputs', () {
    testWidgets('checkbox toggles from its label', (tester) async {
      var value = false;

      await pumpSrWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) => SrCheckbox(
            value: value,
            label: 'Remember me',
            onChanged: (nextValue) => setState(() => value = nextValue),
          ),
        ),
      );

      await tester.tap(find.text('Remember me'));
      await tester.pump();

      expect(value, isTrue);
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
    });

    testWidgets('radio reports its typed value', (tester) async {
      String? selected = 'cash';

      await pumpSrWidget(
        tester,
        SrRadio<String>(
          value: 'card',
          groupValue: selected,
          label: 'Card',
          onChanged: (value) => selected = value,
        ),
      );

      await tester.tap(find.text('Card'));

      expect(selected, 'card');
    });

    testWidgets('toggle reports its next state', (tester) async {
      var value = false;

      await pumpSrWidget(
        tester,
        SrToggle(
          value: value,
          label: 'Notifications',
          onChanged: (nextValue) => value = nextValue,
        ),
      );

      await tester.tap(find.byType(Switch));

      expect(value, isTrue);
    });

    testWidgets('star rating exposes each available value', (tester) async {
      double? rating;

      await pumpSrWidget(
        tester,
        SrStarRating(value: 2, onChanged: (value) => rating = value),
      );

      await tester.tap(find.byTooltip('Rating 4 of 5'));

      expect(rating, 4);
    });
  });

  group('value inputs', () {
    testWidgets('slider reports value changes', (tester) async {
      double? value;

      await pumpSrWidget(
        tester,
        SizedBox(
          width: 320,
          child: SrSlider(
            value: 0.25,
            onChanged: (nextValue) => value = nextValue,
          ),
        ),
      );

      await tester.drag(find.byType(Slider), const Offset(80, 0));

      expect(value, isNotNull);
      expect(value!, greaterThan(0.25));
    });

    testWidgets('number input honors its upper bound', (tester) async {
      int? value;

      await pumpSrWidget(
        tester,
        SrNumberInput(
          value: 2,
          min: 1,
          max: 3,
          onChanged: (nextValue) => value = nextValue,
        ),
      );

      await tester.tap(find.byTooltip('Increase'));

      expect(value, 3);
    });

    testWidgets('text field emits edits and presents errors', (tester) async {
      String? value;

      await pumpSrWidget(
        tester,
        SizedBox(
          width: 320,
          child: SrTextField(
            labelText: 'Name',
            hintText: 'Enter a name',
            errorText: 'Required',
            onChanged: (nextValue) => value = nextValue,
          ),
        ),
      );

      final textField = tester.widget<EditableText>(find.byType(EditableText));
      final textFieldDecorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(textField.style.fontSize, SrTypography.bodyMedium.fontSize);
      _expectSameTextMetrics(
        textFieldDecorator.decoration.hintStyle,
        textField.style,
        sample: 'Enter a name',
      );

      await tester.enterText(find.byType(TextFormField), 'Rio');

      expect(value, 'Rio');
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('resting field label shares placeholder text metrics', (
      tester,
    ) async {
      await pumpSrWidget(
        tester,
        SizedBox(
          width: 320,
          child: SrTextField(
            labelText: 'Uang diterima',
            hintText: 'Contoh: 50000',
            size: SrComponentSize.small,
          ),
        ),
      );

      final textField = tester.widget<EditableText>(find.byType(EditableText));
      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );

      _expectSameTextMetrics(
        decorator.decoration.labelStyle,
        textField.style,
        sample: 'Uang diterima',
      );
      final renderedLabelStyle = DefaultTextStyle.of(
        tester.element(find.text('Uang diterima')),
      ).style;
      expect(renderedLabelStyle.fontSize, textField.style.fontSize);
      expect(
        _measureText(renderedLabelStyle, 'Uang diterima').width,
        _measureText(textField.style, 'Uang diterima').width,
      );
      _expectSameTextMetrics(
        decorator.decoration.hintStyle,
        textField.style,
        sample: 'Contoh: 50000',
      );
    });

    testWidgets('small text field reduces padding and keeps touch height', (
      tester,
    ) async {
      await pumpSrWidget(
        tester,
        SizedBox(
          width: 320,
          child: SrTextField(
            hintText: 'Cari menu',
            size: SrComponentSize.small,
          ),
        ),
      );

      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(
        decorator.decoration.contentPadding,
        const EdgeInsets.symmetric(
          horizontal: SrSpacing.space12,
          vertical: SrSpacing.space8,
        ),
      );
      expect(
        tester.getSize(find.byType(TextFormField)).height,
        greaterThanOrEqualTo(48),
      );
    });

    testWidgets('small text, search, and dropdown fields share compact inset', (
      tester,
    ) async {
      await pumpSrWidget(
        tester,
        SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SrTextField(hintText: 'Name', size: SrComponentSize.small),
              SrTextArea(hintText: 'Description', size: SrComponentSize.small),
              SrDropdown<String>(
                hintText: 'Payment method',
                size: SrComponentSize.small,
                items: const [SrDropdownItem(value: 'cash', label: 'Cash')],
                onChanged: _ignore,
              ),
              SrSearchBar(size: SrComponentSize.small, placeholder: 'Search'),
            ],
          ),
        ),
        surfaceSize: const Size(390, 700),
      );

      final expectedPadding = const EdgeInsets.symmetric(
        horizontal: SrSpacing.space12,
        vertical: SrSpacing.space8,
      );
      final decorators = tester.widgetList<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(decorators, hasLength(4));
      expect(
        decorators.map((decorator) => decorator.decoration.contentPadding),
        everyElement(expectedPadding),
      );
      final search = tester.widget<TextField>(find.byType(TextField).last);
      expect(search.decoration?.contentPadding, expectedPadding);
      final inputDecorators = decorators.toList();
      final editableTexts = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();
      _expectSameTextMetrics(
        inputDecorators[0].decoration.hintStyle,
        editableTexts[0].style,
        sample: 'Name',
      );
      _expectSameTextMetrics(
        inputDecorators[1].decoration.hintStyle,
        editableTexts[1].style,
        sample: 'Description',
      );
      _expectSameTextMetrics(
        inputDecorators[3].decoration.hintStyle,
        editableTexts[2].style,
        sample: 'Search',
      );
      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      _expectSameTextMetrics(
        tester.widget<Text>(find.text('Payment method')).style,
        dropdown.style,
        sample: 'Payment method',
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('text area supports multiline input', (tester) async {
      String? value;

      await pumpSrWidget(
        tester,
        SizedBox(
          width: 320,
          child: SrTextArea(
            hintText: 'Add details',
            onChanged: (nextValue) => value = nextValue,
          ),
        ),
      );

      final textArea = tester.widget<EditableText>(find.byType(EditableText));
      final textAreaDecorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(textArea.style.fontSize, SrTypography.bodyMedium.fontSize);
      _expectSameTextMetrics(
        textAreaDecorator.decoration.hintStyle,
        textArea.style,
        sample: 'Add details',
      );

      await tester.enterText(find.byType(TextFormField), 'First\nSecond');

      expect(value, 'First\nSecond');
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).minLines,
        4,
      );
    });

    testWidgets('dropdown returns the selected typed item', (tester) async {
      String? selected;

      await pumpSrWidget(
        tester,
        SizedBox(
          width: 320,
          child: SrDropdown<String>(
            hintText: 'Payment method',
            items: const [
              SrDropdownItem(value: 'cash', label: 'Cash'),
              SrDropdownItem(value: 'card', label: 'Card'),
            ],
            onChanged: (value) => selected = value,
          ),
        ),
      );

      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      final hint = tester.widget<Text>(find.text('Payment method'));
      expect(dropdown.style?.fontSize, SrTypography.bodyMedium.fontSize);
      _expectSameTextMetrics(
        hint.style,
        dropdown.style,
        sample: 'Payment method',
      );

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Card').last);
      await tester.pumpAndSettle();

      expect(selected, 'card');
    });

    testWidgets('search bar transitions to filled and can clear', (
      tester,
    ) async {
      final changes = <String>[];
      var cleared = false;

      await pumpSrWidget(
        tester,
        SizedBox(
          width: 320,
          child: SrSearchBar(
            placeholder: 'Search products',
            onChanged: changes.add,
            onCleared: () => cleared = true,
          ),
        ),
      );

      expect(find.text('Search products'), findsOneWidget);
      expect(find.byTooltip('Clear search'), findsNothing);

      final searchField = tester.widget<TextField>(find.byType(TextField));
      expect(searchField.style?.fontSize, SrTypography.bodyMedium.fontSize);
      _expectSameTextMetrics(
        searchField.decoration?.hintStyle,
        searchField.style,
        sample: 'Search products',
      );

      await tester.enterText(find.byType(TextField), 'Shoes');
      await tester.pump();
      expect(find.byTooltip('Clear search'), findsOneWidget);

      await tester.tap(find.byTooltip('Clear search'));
      await tester.pump();

      expect(changes, containsAllInOrder(['Shoes', '']));
      expect(cleared, isTrue);
      expect(find.text('Search products'), findsOneWidget);
    });

    testWidgets('search placeholder and value use identical text metrics', (
      tester,
    ) async {
      await pumpSrWidget(
        tester,
        const SizedBox(width: 320, child: SrSearchBar(placeholder: 'Search')),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      final valueStyle = field.style!;
      final placeholderStyle = field.decoration!.hintStyle!;

      _expectSameTextMetrics(placeholderStyle, valueStyle, sample: 'Search');

      await tester.enterText(find.byType(TextField), 'Search');
      await tester.pump();

      final filledField = tester.widget<TextField>(find.byType(TextField));
      expect(filledField.style, valueStyle);
    });
  });
}

void _ignore(String? _) {}

void _expectSameTextMetrics(
  TextStyle? hintStyle,
  TextStyle? valueStyle, {
  required String sample,
}) {
  expect(hintStyle, isNotNull);
  expect(valueStyle, isNotNull);
  final hint = hintStyle!;
  final value = valueStyle!;
  expect(hint.fontFamily, value.fontFamily);
  expect(hint.fontFamilyFallback, value.fontFamilyFallback);
  expect(hint.fontSize, value.fontSize);
  expect(hint.fontWeight, value.fontWeight);
  expect(hint.fontStyle, value.fontStyle);
  expect(hint.letterSpacing, value.letterSpacing);
  expect(hint.wordSpacing, value.wordSpacing);
  expect(hint.height, value.height);
  expect(hint.textBaseline, value.textBaseline);
  expect(hint.leadingDistribution, value.leadingDistribution);
  expect(hint.fontFeatures, value.fontFeatures);
  expect(hint.fontVariations, value.fontVariations);

  expect(_measureText(hint, sample), _measureText(value, sample));
}

Size _measureText(TextStyle style, String sample) {
  final painter = TextPainter(
    text: TextSpan(text: sample, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  return painter.size;
}
