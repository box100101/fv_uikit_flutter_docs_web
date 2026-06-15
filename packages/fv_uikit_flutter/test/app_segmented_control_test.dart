import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('AppSegmentedControl', () {
    testWidgets('renders items, counts as badges and handles selection', (WidgetTester tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        buildApp(
          AppSegmentedControl(
            items: const [
              AppSegmentedControlItem(label: 'Tab 1', count: 5),
              AppSegmentedControlItem(label: 'Tab 2', count: 10),
            ],
            selectedIndex: selectedIndex,
            onSelected: (index) {
              selectedIndex = index;
            },
          ),
        ),
      );

      // Verify labels are rendered
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);

      // Verify counts are rendered inside AppBadges
      expect(find.text('5'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.byType(AppBadge), findsNWidgets(2));

      // Tap tab 2
      await tester.tap(find.text('Tab 2'));
      await tester.pump();

      expect(selectedIndex, 1);
    });

    testWidgets('renders items with dynamic icon colors in tablet style', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildApp(
          AppSegmentedControl(
            style: AppSegmentedControlStyle.tablet,
            items: const [
              AppSegmentedControlItem(
                label: 'Tab 1',
                icon: Icon(Icons.star, key: Key('star-icon-1')),
              ),
              AppSegmentedControlItem(
                label: 'Tab 2',
                icon: Icon(Icons.star, key: Key('star-icon-2')),
              ),
            ],
            selectedIndex: 0,
            onSelected: (_) {},
          ),
        ),
      );

      // Selected item icon color (active -> ColorTokens.textLight)
      final iconThemeActive = tester.firstWidget<IconTheme>(
        find.ancestor(
          of: find.byKey(const Key('star-icon-1')),
          matching: find.byType(IconTheme),
        ),
      );
      expect(iconThemeActive.data.color, ColorTokens.textLight);

      // Unselected item icon color (inactive -> ColorTokens.textDefault)
      final iconThemeInactive = tester.firstWidget<IconTheme>(
        find.ancestor(
          of: find.byKey(const Key('star-icon-2')),
          matching: find.byType(IconTheme),
        ),
      );
      expect(iconThemeInactive.data.color, ColorTokens.textDefault);
    });

    testWidgets('renders mobile style with icons, badges and spacing', (WidgetTester tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        buildApp(
          AppSegmentedControl(
            style: AppSegmentedControlStyle.mobile,
            items: const [
              AppSegmentedControlItem(
                label: 'Mobile Tab 1',
                icon: Icon(Icons.home, key: Key('home-icon-mobile')),
                count: 3,
              ),
              AppSegmentedControlItem(
                label: 'Mobile Tab 2',
                icon: Icon(Icons.settings, key: Key('settings-icon-mobile')),
                count: 8,
              ),
            ],
            selectedIndex: selectedIndex,
            onSelected: (index) {
              selectedIndex = index;
            },
          ),
        ),
      );

      // Verify labels, icons and badges are rendered
      expect(find.text('Mobile Tab 1'), findsOneWidget);
      expect(find.text('Mobile Tab 2'), findsOneWidget);
      expect(find.byKey(const Key('home-icon-mobile')), findsOneWidget);
      expect(find.byKey(const Key('settings-icon-mobile')), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);

      // Verify spacing exists between items in the Row
      expect(find.byType(SizedBox), findsWidgets);

      // Verify mobile style icon colors
      // Selected (active -> ColorTokens.primaryDefault)
      final iconThemeActive = tester.firstWidget<IconTheme>(
        find.ancestor(
          of: find.byKey(const Key('home-icon-mobile')),
          matching: find.byType(IconTheme),
        ),
      );
      expect(iconThemeActive.data.color, ColorTokens.primaryDefault);

      // Unselected (inactive -> ColorTokens.textDefault)
      final iconThemeInactive = tester.firstWidget<IconTheme>(
        find.ancestor(
          of: find.byKey(const Key('settings-icon-mobile')),
          matching: find.byType(IconTheme),
        ),
      );
      expect(iconThemeInactive.data.color, ColorTokens.textDefault);

      // Tap tab 2
      await tester.tap(find.text('Mobile Tab 2'));
      await tester.pump();

      expect(selectedIndex, 1);
    });
  });

  group('AppSegmentedTabScaffold', () {
    testWidgets('renders tab items, switches content and handles lazy load', (WidgetTester tester) async {
      int tabChangedCount = 0;

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            height: 300,
            child: AppSegmentedTabScaffold(
              tabs: const [
                AppSegmentedTabScaffoldItem(
                  controlItem: AppSegmentedControlItem(label: 'Tab A'),
                  content: Text('Content A'),
                  lazyLoad: false,
                ),
                AppSegmentedTabScaffoldItem(
                  controlItem: AppSegmentedControlItem(label: 'Tab B'),
                  content: Text('Content B'),
                  // lazyLoad: true
                ),
              ],
              onTabChanged: (_) {
                tabChangedCount++;
              },
            ),
          ),
        ),
      );

      // Verify Tab A content is rendered (eager load/initial tab)
      expect(find.text('Content A'), findsOneWidget);

      // Verify Tab B content is NOT rendered (lazy load)
      expect(find.text('Content B'), findsNothing);

      // Tap Tab B
      await tester.tap(find.text('Tab B'));
      await tester.pumpAndSettle();

      // Verify Tab B content is now rendered
      expect(find.text('Content B'), findsOneWidget);
      expect(tabChangedCount, 1);
    });

    testWidgets('slide animation: tab content slides correctly when animated is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            height: 300,
            child: AppSegmentedTabScaffold(
              animated: true,
              tabs: const [
                AppSegmentedTabScaffoldItem(
                  controlItem: AppSegmentedControlItem(label: 'Tab A'),
                  content: Text('Content A'),
                  lazyLoad: false,
                ),
                AppSegmentedTabScaffoldItem(
                  controlItem: AppSegmentedControlItem(label: 'Tab B'),
                  content: Text('Content B'),
                  lazyLoad: false,
                ),
              ],
            ),
          ),
        ),
      );

      // Initial state: Tab A is visible
      expect(find.text('Content A'), findsOneWidget);

      // Tap Tab B — animation starts
      await tester.tap(find.text('Tab B'));
      await tester.pump(); // start frame

      // Mid-animation: both tabs exist in the widget tree
      expect(find.text('Content A'), findsOneWidget);
      expect(find.text('Content B'), findsOneWidget);

      // After animation settles
      await tester.pumpAndSettle();

      // Tab B is now active and fully visible
      expect(find.text('Content B'), findsOneWidget);
    });

    testWidgets('no animation: tab switches instantly when animated is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            height: 300,
            child: AppSegmentedTabScaffold(
              animated: false,
              tabs: const [
                AppSegmentedTabScaffoldItem(
                  controlItem: AppSegmentedControlItem(label: 'Tab A'),
                  content: Text('Content A'),
                  lazyLoad: false,
                ),
                AppSegmentedTabScaffoldItem(
                  controlItem: AppSegmentedControlItem(label: 'Tab B'),
                  content: Text('Content B'),
                  lazyLoad: false,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tab B'));
      await tester.pump(); // single frame — no animation controller needed

      // Tab B is immediately active with no animation delay
      expect(find.text('Content B'), findsOneWidget);
    });

    testWidgets('keep-state: switching back to previous tab does not re-run initState', (WidgetTester tester) async {
      // Track initState calls using a counter passed by reference via ValueNotifier
      final initCounts = <int>[0, 0]; // initCount for Tab A, Tab B

      Widget buildTrackedTab(int tabIndex) {
        return _InitCounterWidget(onInit: () => initCounts[tabIndex]++);
      }

      await tester.pumpWidget(
        buildApp(
          SizedBox(
            height: 300,
            child: AppSegmentedTabScaffold(
              animated: false,
              tabs: [
                AppSegmentedTabScaffoldItem(
                  controlItem: const AppSegmentedControlItem(label: 'Tab A'),
                  content: buildTrackedTab(0),
                  lazyLoad: false,
                ),
                AppSegmentedTabScaffoldItem(
                  controlItem: const AppSegmentedControlItem(label: 'Tab B'),
                  content: buildTrackedTab(1),
                ),
              ],
            ),
          ),
        ),
      );

      // Tab A is initialized on mount (eager load)
      expect(initCounts[0], 1);
      // Tab B is NOT initialized yet (lazy load)
      expect(initCounts[1], 0);

      // Switch to Tab B — Tab B initializes for the first time
      await tester.tap(find.text('Tab B'));
      await tester.pumpAndSettle();
      expect(initCounts[1], 1);

      // Switch back to Tab A — must NOT re-run initState
      await tester.tap(find.text('Tab A'));
      await tester.pumpAndSettle();
      expect(initCounts[0], 1, reason: 'Tab A must NOT re-initialize when switching back');

      // Switch to Tab B again — must NOT re-run initState
      await tester.tap(find.text('Tab B'));
      await tester.pumpAndSettle();
      expect(initCounts[1], 1, reason: 'Tab B must NOT re-initialize on second visit');
    });
  });
}

/// Widget test helper: gọi [onInit] trong initState để đếm số lần khởi tạo.
class _InitCounterWidget extends StatefulWidget {
  final VoidCallback onInit;

  const _InitCounterWidget({required this.onInit});

  @override
  State<_InitCounterWidget> createState() => _InitCounterWidgetState();
}

class _InitCounterWidgetState extends State<_InitCounterWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
