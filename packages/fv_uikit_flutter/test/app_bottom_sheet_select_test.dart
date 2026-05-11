import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  Color triggerBackgroundColor(WidgetTester tester) {
    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );

    return (container.decoration! as BoxDecoration).color!;
  }

  Future<void> openSelectSheet(WidgetTester tester) async {
    await tester.tap(find.byType(AppTextField).last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
  }

  group('AppBottomSheetSelect', () {
    testWidgets('uses normal field styling when enabled without selection', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppBottomSheetSelect<String>.single(
            labelText: 'Status',
            hintText: 'Choose status',
            items: const ['Open', 'Closed'],
            value: null,
            itemAsString: (item) => item,
            onChanged: (_) {},
          ),
        ),
      );

      expect(triggerBackgroundColor(tester), ColorTokens.bgContainer);
    });

    testWidgets('uses disabled styling only when disabled', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppBottomSheetSelect<String>.single(
            labelText: 'Status',
            hintText: 'Choose status',
            items: const ['Open', 'Closed'],
            value: null,
            itemAsString: (item) => item,
            onChanged: (_) {},
            isDisabled: true,
          ),
        ),
      );

      expect(triggerBackgroundColor(tester), ColorTokens.bgContainerDisabled);
    });

    testWidgets('single mode selects an item and closes the sheet', (
      tester,
    ) async {
      String? selectedValue;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder:
                (context, setState) => AppBottomSheetSelect<String>.single(
                  labelText: 'Tax method',
                  hintText: 'Choose tax method',
                  items: const ['Direct', 'Deduction'],
                  value: selectedValue,
                  itemAsString: (item) => item,
                  onChanged: (value) => setState(() => selectedValue = value),
                  sheetTitle: 'Tax method',
                ),
          ),
        ),
      );

      await openSelectSheet(tester);

      expect(find.text('Tax method'), findsNWidgets(2));
      expect(
        find.descendant(
          of: find.byType(AppBottomSheet),
          matching: find.text('Direct'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Deduction'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(selectedValue, 'Deduction');
      expect(find.text('Deduction'), findsOneWidget);
      expect(find.byType(AppBottomSheet), findsNothing);
    });

    testWidgets('single mode unselects when tapping the selected item', (
      tester,
    ) async {
      String? selectedValue = 'Direct';

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder:
                (context, setState) => AppBottomSheetSelect<String>.single(
                  labelText: 'Tax method',
                  hintText: 'Choose tax method',
                  items: const ['Direct', 'Deduction'],
                  value: selectedValue,
                  itemAsString: (item) => item,
                  onChanged: (value) => setState(() => selectedValue = value),
                  sheetTitle: 'Tax method',
                ),
          ),
        ),
      );

      expect(find.text('Direct'), findsOneWidget);

      await openSelectSheet(tester);
      await tester.tap(find.text('Direct').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(selectedValue, isNull);
      expect(find.byType(AppBottomSheet), findsNothing);
      expect(find.text('Choose tax method'), findsOneWidget);
    });

    testWidgets(
      'clear icon resets single selection before reopening the sheet',
      (tester) async {
        String? selectedValue;

        await tester.pumpWidget(
          buildApp(
            StatefulBuilder(
              builder:
                  (context, setState) => AppBottomSheetSelect<String>.single(
                    labelText: 'Tax method',
                    hintText: 'Choose tax method',
                    items: const ['Direct', 'Deduction'],
                    value: selectedValue,
                    itemAsString: (item) => item,
                    onChanged: (value) => setState(() => selectedValue = value),
                    sheetTitle: 'Tax method',
                  ),
            ),
          ),
        );

        await openSelectSheet(tester);
        await tester.tap(find.text('Direct').last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        expect(selectedValue, 'Direct');

        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pump();

        expect(selectedValue, isNull);
        expect(find.text('Choose tax method'), findsOneWidget);

        await openSelectSheet(tester);
        await tester.tap(find.text('Direct').last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        expect(selectedValue, 'Direct');
      },
    );

    testWidgets('multi mode keeps draft selection until apply is pressed', (
      tester,
    ) async {
      List<String> selectedValues = const ['Template 1'];
      List<String>? lastCallbackValue;

      await tester.pumpWidget(
        buildApp(
          StatefulBuilder(
            builder:
                (context, setState) => AppBottomSheetSelect<String>.multi(
                  labelText: 'Invoice templates',
                  hintText: 'Choose templates',
                  items: const ['Template 1', 'Template 2', 'Template 3'],
                  values: selectedValues,
                  itemAsString: (item) => item,
                  onChanged: (values) {
                    lastCallbackValue = values;
                    setState(() => selectedValues = values);
                  },
                  sheetTitle: 'Invoice templates',
                ),
          ),
        ),
      );

      await openSelectSheet(tester);

      await tester.tap(find.text('Template 2'));
      await tester.pump();

      expect(lastCallbackValue, isNull);

      await tester.tap(find.text('Apply'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(lastCallbackValue, ['Template 1', 'Template 2']);
      expect(find.byType(AppBottomSheet), findsNothing);
    });

    testWidgets('local search filters the options in the sheet', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppBottomSheetSelect<String>.single(
            labelText: 'Fruit',
            hintText: 'Choose fruit',
            items: const ['Apple', 'Banana', 'Cherry'],
            value: null,
            itemAsString: (item) => item,
            onChanged: (_) {},
            isSearchable: true,
            searchHintText: 'Search fruit',
            sheetTitle: 'Fruit',
          ),
        ),
      );

      await openSelectSheet(tester);

      await tester.enterText(find.byType(EditableText).last, 'ban');
      await tester.pump();

      final sheetFinder = find.byType(AppBottomSheet);

      expect(
        find.descendant(of: sheetFinder, matching: find.text('Apple')),
        findsNothing,
      );
      expect(
        find.descendant(of: sheetFinder, matching: find.text('Banana')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: sheetFinder, matching: find.text('Cherry')),
        findsNothing,
      );
    });

    testWidgets('rebuilds the open sheet when remote data changes', (
      tester,
    ) async {
      final hostKey = GlobalKey<_RemoteSelectHostState>();

      await tester.pumpWidget(buildApp(_RemoteSelectHost(key: hostKey)));

      await openSelectSheet(tester);

      expect(find.text('Đang tải dữ liệu...'), findsOneWidget);

      hostKey.currentState!.resolveItems();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Remote option 1'), findsOneWidget);
      expect(find.text('Đang tải dữ liệu...'), findsNothing);
    });

    testWidgets('calls onLoadMore when scrolled near the end in remote mode', (
      tester,
    ) async {
      var loadMoreCalls = 0;
      final items = List<String>.generate(20, (index) => 'Option $index');

      await tester.pumpWidget(
        buildApp(
          AppBottomSheetSelect<String>.single(
            labelText: 'Remote options',
            hintText: 'Choose option',
            items: items,
            value: null,
            itemAsString: (item) => item,
            onChanged: (_) {},
            isSearchable: true,
            enableLocalFilter: false,
            hasMore: true,
            onLoadMore: () {
              loadMoreCalls += 1;
            },
            sheetTitle: 'Remote options',
          ),
        ),
      );

      await openSelectSheet(tester);

      await tester.drag(find.byType(ListView), const Offset(0, -800));
      await tester.pump();

      expect(loadMoreCalls, 1);
    });

    testWidgets('closing the sheet does not throw async dispose errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppBottomSheetSelect<String>.single(
            labelText: 'Status',
            hintText: 'Choose status',
            items: const ['Open', 'Closed'],
            value: null,
            itemAsString: (item) => item,
            onChanged: (_) {},
            isSearchable: true,
          ),
        ),
      );

      await openSelectSheet(tester);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(AppBottomSheet), findsNothing);
    });
  });
}

class _RemoteSelectHost extends StatefulWidget {
  const _RemoteSelectHost({super.key});

  @override
  State<_RemoteSelectHost> createState() => _RemoteSelectHostState();
}

class _RemoteSelectHostState extends State<_RemoteSelectHost> {
  List<String> items = const <String>[];
  bool isLoading = true;

  void resolveItems() {
    setState(() {
      items = const ['Remote option 1', 'Remote option 2'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetSelect<String>.single(
      labelText: 'Remote',
      hintText: 'Choose option',
      items: items,
      value: null,
      itemAsString: (item) => item,
      onChanged: (_) {},
      isSearchable: true,
      enableLocalFilter: false,
      isLoading: isLoading,
      sheetTitle: 'Remote',
    );
  }
}
