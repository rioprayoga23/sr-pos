import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:sr_pos/core/design_system/components/chat/chat.dart';
import 'package:sr_pos/core/design_system/components/progress/progress.dart';
import 'package:sr_pos/core/design_system/foundations/sr_spacing.dart';
import 'package:sr_pos/core/design_system/previews/sr_preview_wrapper.dart';

@Preview(
  name: 'Progress and Chat',
  group: 'SR-POS Design System',
  size: Size(390, 900),
  wrapper: srDesignSystemPreviewWrapper,
)
Widget srProgressChatPreview() {
  return const _ProgressChatPreview();
}

class _ProgressChatPreview extends StatefulWidget {
  const _ProgressChatPreview();

  @override
  State<_ProgressChatPreview> createState() => _ProgressChatPreviewState();
}

class _ProgressChatPreviewState extends State<_ProgressChatPreview> {
  final _messageController = TextEditingController();
  var _page = 1;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SrPreviewPage(
      children: [
        SrPreviewSection(
          title: 'Progress',
          child: Column(
            children: [
              const SrProgressBar(
                value: 0.65,
                label: 'Uploading',
                showPercentage: true,
              ),
              const SizedBox(height: SrSpacing.space16),
              SrPaginationDots(
                itemCount: 3,
                currentIndex: _page,
                onDotPressed: (value) => setState(() => _page = value),
              ),
              const SizedBox(height: SrSpacing.space16),
              const SrLoader(label: 'Please wait'),
              const SizedBox(height: SrSpacing.space16),
              SrStepper(
                steps: const [
                  SrStepperStep(label: 'Cart', status: SrStepStatus.completed),
                  SrStepperStep(
                    label: 'Delivery',
                    status: SrStepStatus.current,
                  ),
                  SrStepperStep(
                    label: 'Payment',
                    status: SrStepStatus.upcoming,
                  ),
                ],
              ),
            ],
          ),
        ),
        SrPreviewSection(
          title: 'Chat',
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: SrMessageBubble(
                  message: 'Hello, how can I help?',
                  sender: 'Cashier',
                  timestamp: '09:41',
                  direction: SrMessageDirection.incoming,
                ),
              ),
              const SizedBox(height: SrSpacing.space8),
              const Align(
                alignment: Alignment.centerRight,
                child: SrMessageBubble(
                  message: 'Please prepare my order.',
                  timestamp: '09:42',
                  status: Icon(Icons.done_all_rounded),
                  direction: SrMessageDirection.outgoing,
                ),
              ),
              const SizedBox(height: SrSpacing.space12),
              SrMessageInput(
                controller: _messageController,
                onSend: (_) => setState(_messageController.clear),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
