import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  testWidgets('AppSearchFilterBar renders search field and filter button with default values', (WidgetTester tester) async {
    bool filterTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchFilterBar(
            onFilterTap: () {
              filterTapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.byType(AppSearchField), findsOneWidget);
    expect(find.text('Lọc'), findsOneWidget);

    await tester.tap(find.text('Lọc'));
    await tester.pump();

    expect(filterTapped, true);
  });

  testWidgets('AppSearchFilterBar renders and callbacks with custom filterLabel', (WidgetTester tester) async {
    bool filterTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchFilterBar(
            onFilterTap: () {
              filterTapped = true;
            },
            filterLabel: 'Tìm Bộ Lọc',
          ),
        ),
      ),
    );

    expect(find.text('Lọc'), findsNothing);
    expect(find.text('Tìm Bộ Lọc'), findsOneWidget);

    await tester.tap(find.text('Tìm Bộ Lọc'));
    await tester.pump();

    expect(filterTapped, true);
  });

  testWidgets('AppSearchFilterBar active vs inactive style variations', (WidgetTester tester) async {
    // 1. Active State
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchFilterBar(
            onFilterTap: () {},
            isFilterActive: true,
          ),
        ),
      ),
    );

    final activeInk = tester.widget<Ink>(
      find.descendant(
        of: find.byType(Material),
        matching: find.byType(Ink),
      ),
    );
    final activeDecoration = activeInk.decoration as BoxDecoration;
    expect(activeDecoration.color, ColorTokens.primaryBg);
    expect(
      (activeDecoration.border as Border).top.color,
      ColorTokens.primaryDefault,
    );

    // 2. Inactive State
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchFilterBar(
            onFilterTap: () {},
            isFilterActive: false,
          ),
        ),
      ),
    );

    final inactiveInk = tester.widget<Ink>(
      find.descendant(
        of: find.byType(Material),
        matching: find.byType(Ink),
      ),
    );
    final inactiveDecoration = inactiveInk.decoration as BoxDecoration;
    expect(inactiveDecoration.color, ColorTokens.bgContainer);
    expect(
      (inactiveDecoration.border as Border).top.color,
      ColorTokens.borderSecondary,
    );
  });

  testWidgets('AppSearchFilterBar search debounce verification', (WidgetTester tester) async {
    String searchVal = '';
    int callCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchFilterBar(
            onFilterTap: () {},
            onSearchChanged: (val) {
              searchVal = val;
              callCount++;
            },
            searchDelay: 300,
          ),
        ),
      ),
    );

    // Nhập text
    await tester.enterText(find.byType(TextField), 'apple');
    
    // Vì có 300ms debounce, callback chưa được gọi ngay lập tức
    expect(callCount, 0);
    expect(searchVal, '');

    // Pump một khoảng thời gian nhỏ hơn 300ms (ví dụ 100ms)
    await tester.pump(const Duration(milliseconds: 100));
    expect(callCount, 0);

    // Pump nốt khoảng thời gian còn lại (200ms) để trigger callback
    await tester.pump(const Duration(milliseconds: 200));
    expect(callCount, 1);
    expect(searchVal, 'apple');
  });
}
