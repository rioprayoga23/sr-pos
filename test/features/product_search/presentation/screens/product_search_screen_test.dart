import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sr_pos/core/design_system/components/input/sr_search_bar.dart';
import 'package:sr_pos/core/design_system/theme/sr_theme.dart';
import 'package:sr_pos/features/product_search/data/repositories/in_memory_product_repository.dart';
import 'package:sr_pos/features/product_search/presentation/screens/product_search_screen.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_ui_state.dart';
import 'package:sr_pos/features/product_search/presentation/view_models/product_search_view_model.dart';

void main() {
  group('ProductSearchScreen', () {
    late ProductSearchViewModel viewModel;

    setUp(() async {
      viewModel = ProductSearchViewModel(const InMemoryProductRepository());
      await viewModel.load();
    });

    tearDown(() => viewModel.dispose());

    testWidgets('renders the Figma reference content', (tester) async {
      await _pumpScreen(tester, viewModel);

      expect(find.byType(SrSearchBar), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Shoes'), findsOneWidget);
      expect(find.text('Sort'), findsOneWidget);
      expect(find.text('Filter'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Amazing Shoes'), findsOneWidget);
      expect(find.text('Wonderful Shoes'), findsOneWidget);
      expect(find.text('€12'), findsNWidgets(3));
      expect(find.text('€15'), findsNWidgets(3));
    });

    testWidgets('updates visible products from search input', (tester) async {
      await _pumpScreen(tester, viewModel);

      await tester.enterText(find.byType(TextField), 'Amazing');
      await tester.pump();

      expect(find.text('Amazing Shoes'), findsOneWidget);
      expect(find.text('Fabulous Shoes'), findsNothing);
    });

    testWidgets('forwards sort and filter interactions', (tester) async {
      await _pumpScreen(tester, viewModel);

      await tester.tap(find.text('Sort'));
      await tester.pump();
      expect(viewModel.state.sort, ProductSortOption.priceLowToHigh);

      await tester.tap(find.text('Filter'));
      await tester.pump();
      expect(viewModel.state.activeFilterCount, 0);
      expect(find.text('2'), findsNothing);
    });
  });
}

Future<void> _pumpScreen(
  WidgetTester tester,
  ProductSearchViewModel viewModel,
) async {
  await tester.binding.setSurfaceSize(const Size(375, 812));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: SrTheme.light,
      home: ProductSearchScreen(viewModel: viewModel),
    ),
  );
  await tester.pump();
}
