import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

double? spacingBetweenIconAndLabel(WidgetTester tester, String label) {
  final Finder labelFinder = findBottomNavigatorLabel(label);
  final Finder columnFinder = find.ancestor(
    of: labelFinder,
    matching: find.byType(Column),
  );
  final Column column = tester.widget<Column>(columnFinder.first);
  final SizedBox spacer = column.children[1] as SizedBox;

  return spacer.height;
}

Finder findBottomNavigatorLabel(String text) {
  return find.byWidgetPredicate(
    (Widget widget) =>
        widget is Text &&
        widget.data == text &&
        widget.overflow == TextOverflow.ellipsis,
    description: 'AppBottomNavigator label "$text"',
  );
}

void main() {
  Widget buildApp(Widget child, {Size? surfaceSize}) {
    final Widget scaffold = Scaffold(body: child);

    if (surfaceSize == null) {
      return MaterialApp(home: scaffold);
    }

    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: surfaceSize),
        child: Scaffold(
          body: SizedBox.fromSize(size: surfaceSize, child: child),
        ),
      ),
    );
  }

  List<AppBottomNavigatorItem> buildItems(int count) {
    return List<AppBottomNavigatorItem>.generate(
      count,
      (index) => AppBottomNavigatorItem(
        label: 'Item $index',
        icon: const Icon(Icons.circle_outlined),
        activeIcon: const Icon(Icons.circle),
      ),
    );
  }

  group('AppBottomNavigator', () {
    testWidgets('renders all dynamic items and triggers selected index', (
      tester,
    ) async {
      int? tappedIndex;

      await tester.pumpWidget(
        buildApp(
          AppBottomNavigator(
            items: buildItems(5),
            currentIndex: 1,
            onTap: (index) {
              tappedIndex = index;
            },
          ),
        ),
      );

      expect(findBottomNavigatorLabel('Item 0'), findsOneWidget);
      expect(findBottomNavigatorLabel('Item 4'), findsOneWidget);

      await tester.tap(findBottomNavigatorLabel('Item 3'));
      await tester.pump();

      expect(tappedIndex, 3);
    });

    testWidgets('uses active icon for the selected item', (tester) async {
      await tester.pumpWidget(
        buildApp(AppBottomNavigator(items: buildItems(3), currentIndex: 0)),
      );

      expect(find.byIcon(Icons.circle), findsOneWidget);
      expect(find.byIcon(Icons.circle_outlined), findsNWidgets(2));
    });

    testWidgets('falls back to horizontal scrolling when items overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppBottomNavigator(items: buildItems(6), currentIndex: 0),
          surfaceSize: const Size(320, 120),
        ),
      );

      final SingleChildScrollView scrollView = tester.widget(
        find.byType(SingleChildScrollView),
      );

      expect(scrollView.scrollDirection, Axis.horizontal);
    });

    testWidgets('does not trigger tap for disabled items', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppBottomNavigator(
            items: const [
              AppBottomNavigatorItem(label: 'Home', icon: Icon(Icons.home)),
              AppBottomNavigatorItem(
                label: 'Orders',
                icon: Icon(Icons.receipt_long),
                enabled: false,
              ),
            ],
            currentIndex: 0,
            onTap: (_) {
              tapCount += 1;
            },
          ),
        ),
      );

      await tester.tap(findBottomNavigatorLabel('Orders'));
      await tester.pump();

      expect(tapCount, 0);
    });

    testWidgets(
      'applies custom label size props to active and inactive items',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            AppBottomNavigator(
              items: const [
                AppBottomNavigatorItem(
                  label: 'Home',
                  icon: Icon(Icons.home_outlined),
                ),
                AppBottomNavigatorItem(
                  label: 'Orders',
                  icon: Icon(Icons.receipt_long_outlined),
                ),
              ],
              currentIndex: 0,
              selectedLabelSize: AppTextSize.bodyXLBold,
              unselectedLabelSize: AppTextSize.bodyXSRegular,
            ),
          ),
        );

        final Text activeText = tester.widget<Text>(
          findBottomNavigatorLabel('Home'),
        );
        final Text inactiveText = tester.widget<Text>(
          findBottomNavigatorLabel('Orders'),
        );

        expect(activeText.style?.fontSize, TextStyleTokens.bodyXLBold.fontSize);
        expect(
          inactiveText.style?.fontSize,
          TextStyleTokens.bodyXSRegular.fontSize,
        );
      },
    );

    testWidgets('applies custom spacing between icon and label', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppBottomNavigator(
            items: const [
              AppBottomNavigatorItem(
                label: 'Home',
                icon: Icon(Icons.home_outlined),
              ),
              AppBottomNavigatorItem(
                label: 'Orders',
                icon: Icon(Icons.receipt_long_outlined),
              ),
            ],
            currentIndex: 0,
            labelSpacing: 14,
          ),
        ),
      );

      expect(spacingBetweenIconAndLabel(tester, 'Home'), 14);
      expect(spacingBetweenIconAndLabel(tester, 'Orders'), 14);
    });
  });
}
