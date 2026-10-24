import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sr_pos/core/design_system/design_system.dart';
import 'package:sr_pos/features/sale/presentation/view_models/sale_ui_state.dart';

class SaleOrderList extends StatefulWidget {
  const SaleOrderList({
    required this.items,
    this.onQuantityChanged,
    this.onRemove,
    super.key,
  });

  final List<SaleCartLineViewData> items;
  final void Function(String productId, int quantity)? onQuantityChanged;
  final ValueChanged<String>? onRemove;

  @override
  State<SaleOrderList> createState() => _SaleOrderListState();
}

class _SaleOrderListState extends State<SaleOrderList> {
  late final ScrollController _scrollController;
  var _hasMoreBelow = false;
  var _scrollStateCheckScheduled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(_scheduleScrollStateCheck);
    _scheduleScrollStateCheck();
  }

  @override
  void didUpdateWidget(covariant SaleOrderList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.items, widget.items)) {
      _scheduleScrollStateCheck();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scheduleScrollStateCheck)
      ..dispose();
    super.dispose();
  }

  void _scheduleScrollStateCheck() {
    if (_scrollStateCheckScheduled) return;
    _scrollStateCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollStateCheckScheduled = false;
      if (!mounted || !_scrollController.hasClients) return;

      final hasMoreBelow =
          _scrollController.position.extentAfter > SrSpacing.none;
      if (_hasMoreBelow != hasMoreBelow) {
        setState(() => _hasMoreBelow = hasMoreBelow);
      }
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    final target = _scrollController.position.maxScrollExtent;
    if (MediaQuery.disableAnimationsOf(context)) {
      _scrollController.jumpTo(target);
      return;
    }
    unawaited(
      _scrollController.animateTo(
        target,
        duration: SrMotion.emphasized,
        curve: SrMotion.standardCurve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final motionDuration = MediaQuery.disableAnimationsOf(context)
        ? SrMotion.instant
        : SrMotion.standard;

    return Stack(
      children: [
        Positioned.fill(
          child: NotificationListener<ScrollMetricsNotification>(
            onNotification: (_) {
              _scheduleScrollStateCheck();
              return false;
            },
            child: ListView.separated(
              controller: _scrollController,
              itemCount: widget.items.length,
              separatorBuilder: (_, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: SrSpacing.space4),
                child: SrDivider(),
              ),
              itemBuilder: (context, index) {
                final line = widget.items[index];
                return SrShoppingCartItem(
                  key: ValueKey(line.productId),
                  item: SrShoppingCartItemData(
                    title: line.name,
                    subtitle: line.itemPriceLabel,
                    priceLabel: line.totalLabel,
                    quantity: line.quantity,
                  ),
                  size: SrComponentSize.small,
                  metadata: line.itemNote.isEmpty
                      ? null
                      : Text(
                          'Catatan · ${line.itemNote}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: SrTypography.bodySmall.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                  minimumQuantity: 1,
                  onQuantityChanged: widget.onQuantityChanged == null
                      ? null
                      : (quantity) =>
                            widget.onQuantityChanged!(line.productId, quantity),
                  onRemove: widget.onRemove == null
                      ? null
                      : () => widget.onRemove!(line.productId),
                );
              },
            ),
          ),
        ),
        Positioned(
          left: SrSpacing.none,
          right: SrSpacing.none,
          bottom: SrSpacing.space8,
          child: SizedBox(
            height: SrSizing.minimumTouchTarget,
            child: Center(
              child: IgnorePointer(
                ignoring: !_hasMoreBelow,
                child: AnimatedSwitcher(
                  duration: motionDuration,
                  switchInCurve: SrMotion.standardCurve,
                  switchOutCurve: SrMotion.standardCurve,
                  child: _hasMoreBelow
                      ? IconButton(
                          key: const ValueKey('scroll-to-bottom'),
                          onPressed: _scrollToBottom,
                          tooltip: 'Gulir ke sisa pesanan',
                          style: IconButton.styleFrom(
                            foregroundColor: colors.primary,
                            minimumSize: const Size.square(
                              SrSizing.minimumTouchTarget,
                            ),
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                          ),
                          icon: SizedBox.square(
                            dimension: SrSizing.size32,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: colors.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: SrIcon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: SrIconSize.small,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(
                          key: ValueKey('no-more-orders-below'),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
