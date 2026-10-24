import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/progress/progress.dart';

import '../../../../helpers/pump_sr_widget.dart';

void main() {
  testWidgets('progress components render determinate state and loader', (
    tester,
  ) async {
    await pumpSrWidget(
      tester,
      const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 240,
            child: SrProgressBar(
              value: 0.65,
              label: 'Uploading',
              showPercentage: true,
            ),
          ),
          SizedBox(height: 24),
          SrLoader(label: 'Please wait'),
        ],
      ),
    );

    expect(find.text('Uploading'), findsOneWidget);
    expect(find.text('65%'), findsOneWidget);
    expect(find.text('Please wait'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('pagination and stepper callbacks remain controlled', (
    tester,
  ) async {
    int? selectedPage;
    int? selectedStep;

    await pumpSrWidget(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SrPaginationDots(
            itemCount: 3,
            currentIndex: 1,
            onDotPressed: (value) => selectedPage = value,
          ),
          const SizedBox(height: 24),
          SrStepper(
            steps: const [
              SrStepperStep(label: 'Cart', status: SrStepStatus.completed),
              SrStepperStep(label: 'Delivery', status: SrStepStatus.current),
              SrStepperStep(label: 'Payment', status: SrStepStatus.upcoming),
            ],
            onStepPressed: (value) => selectedStep = value,
          ),
        ],
      ),
    );

    await tester.tap(find.bySemanticsLabel('Page 3 of 3'));
    expect(selectedPage, 2);

    await tester.tap(find.text('Payment'));
    expect(selectedStep, 2);
  });
}
