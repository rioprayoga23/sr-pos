import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/chat/chat.dart';
import 'package:sr_pos/core/design_system/foundations/sr_typography.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  testWidgets('message bubbles support incoming and outgoing content', (
    tester,
  ) async {
    await pumpSrWidget(
      tester,
      const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SrMessageBubble(
            message: 'Hello',
            sender: 'Cashier',
            timestamp: '09:41',
            direction: SrMessageDirection.incoming,
          ),
          SrMessageBubble(
            message: 'Order received',
            timestamp: '09:42',
            status: Icon(Icons.done_all_rounded),
            direction: SrMessageDirection.outgoing,
          ),
        ],
      ),
    );

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Order received'), findsOneWidget);
    expect(find.byIcon(Icons.done_all_rounded), findsOneWidget);
  });

  testWidgets('message input only sends non-empty trimmed messages', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    String? sentMessage;

    await pumpSrWidget(
      tester,
      SrMessageInput(
        controller: controller,
        onSend: (message) => sentMessage = message,
      ),
    );

    final sendButton = find.widgetWithIcon(IconButton, Icons.send_rounded);
    expect(tester.widget<IconButton>(sendButton).onPressed, isNull);

    final messageField = tester.widget<TextField>(find.byType(TextField));
    expect(messageField.style?.fontSize, SrTypography.bodyMedium.fontSize);
    _expectSameTextMetrics(
      messageField.decoration?.hintStyle,
      messageField.style,
      sample: 'Message',
    );

    await tester.enterText(find.byType(TextField), '  Ready  ');
    await tester.pump();
    await tester.tap(sendButton);

    expect(sentMessage, 'Ready');
  });
}

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
  expect(hint.fontSize, value.fontSize);
  expect(hint.fontWeight, value.fontWeight);
  expect(hint.letterSpacing, value.letterSpacing);
  expect(hint.height, value.height);

  Size measure(TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: sample, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.size;
  }

  expect(measure(hint), measure(value));
}
