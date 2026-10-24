import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/input/input.dart';
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
      expect(
        textFieldDecorator.decoration.hintStyle?.fontSize,
        textField.style.fontSize,
      );

      await tester.enterText(find.byType(TextFormField), 'Rio');

      expect(value, 'Rio');
      expect(find.text('Required'), findsOneWidget);
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
      expect(
        textAreaDecorator.decoration.hintStyle?.fontSize,
        textArea.style.fontSize,
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
      expect(hint.style?.fontSize, dropdown.style?.fontSize);

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
      expect(
        searchField.decoration?.hintStyle?.fontSize,
        searchField.style?.fontSize,
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

      expect(placeholderStyle.fontFamily, valueStyle.fontFamily);
      expect(placeholderStyle.fontSize, valueStyle.fontSize);
      expect(placeholderStyle.fontWeight, valueStyle.fontWeight);
      expect(placeholderStyle.fontVariations, valueStyle.fontVariations);

      Size measure(TextStyle style) {
        final painter = TextPainter(
          text: TextSpan(text: 'Search', style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        return painter.size;
      }

      expect(measure(placeholderStyle), measure(valueStyle));

      await tester.enterText(find.byType(TextField), 'Search');
      await tester.pump();

      final filledField = tester.widget<TextField>(find.byType(TextField));
      expect(filledField.style, valueStyle);
    });
  });
}
