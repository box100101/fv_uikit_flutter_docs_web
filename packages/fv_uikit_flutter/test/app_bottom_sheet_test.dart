import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('AppBottomSheet', () {
    testWidgets('renders title description handle close icon and body', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const AppBottomSheet(
            title: 'Sheet title',
            description: 'Sheet description',
            child: AppText(text: 'Sheet body'),
          ),
        ),
      );

      expect(find.text('Sheet title'), findsOneWidget);
      expect(find.text('Sheet description'), findsOneWidget);
      expect(find.text('Sheet body'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('builds default footer actions', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppBottomSheet(
            title: 'Sheet title',
            titleCancelAction: 'Cancel',
            titleSecondaryAction: 'Back',
            titlePrimaryAction: 'Save',
            onCancelAction: () {},
            onSecondaryAction: () {},
            onPrimaryAction: () {},
            child: const AppText(text: 'Sheet body'),
          ),
        ),
      );

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('close icon calls provided callback', (tester) async {
      var closeCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppBottomSheet(
            title: 'Sheet title',
            onClose: () {
              closeCount += 1;
            },
            child: const AppText(text: 'Sheet body'),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(closeCount, 1);
    });

    testWidgets('centers title and places close icon at top right', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const AppBottomSheet(
            title: 'Centered title',
            useSafeArea: false,
            child: AppText(text: 'Sheet body'),
          ),
        ),
      );

      final sheet = find.byType(Container).first;
      final title = find.text('Centered title');
      final closeIcon = find.byIcon(Icons.close);

      expect(
        tester.getCenter(title).dx,
        closeTo(tester.getCenter(sheet).dx, 1),
      );
      expect(
        tester.getTopRight(closeIcon).dx,
        closeTo(tester.getTopRight(sheet).dx - SpacingTokens.paddingXL, 1),
      );
      expect(
        tester.getTopRight(closeIcon).dy,
        closeTo(tester.getTopRight(sheet).dy + SpacingTokens.paddingXL, 1),
      );
    });

    testWidgets('supports custom title, close, drag and radius styling', (
      tester,
    ) async {
      const radius = BorderRadius.vertical(top: Radius.circular(28));

      await tester.pumpWidget(
        buildApp(
          const AppBottomSheet(
            title: 'Custom sheet',
            titleColor: ColorTokens.danger,
            titleStyle: TextStyle(fontSize: 30),
            closeIconColor: ColorTokens.success,
            closeIconSize: 30,
            closeButtonSize: 48,
            dragHandleColor: ColorTokens.warning,
            dragHandleWidth: 72,
            dragHandleHeight: 6,
            dragHandleBottomGap: 2,
            topBorderRadius: radius,
            useSafeArea: false,
            child: AppText(text: 'Sheet body'),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('Custom sheet'));
      final closeIconTheme = IconTheme.of(
        tester.element(find.byIcon(Icons.close)),
      );
      final sheetContainer = tester.widget<Container>(
        find.byType(Container).first,
      );
      final dragHandleFinder = find.byWidgetPredicate((widget) {
        if (widget is! Container) return false;
        final decoration = widget.decoration;
        return decoration is BoxDecoration &&
            decoration.color == ColorTokens.warning;
      });

      expect(title.style?.color, ColorTokens.danger);
      expect(title.style?.fontSize, 30);
      expect(closeIconTheme.size, 30);
      expect(closeIconTheme.color, ColorTokens.success);
      expect(
        (sheetContainer.decoration! as BoxDecoration).borderRadius,
        radius,
      );
      expect(tester.getSize(dragHandleFinder), const Size(72, 6));
    });

    testWidgets(
      'supports horizontal action orientation and custom action style',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const AppBottomSheet(
              title: 'Actions sheet',
              actionOrientation: AppBottomSheetActionOrientation.horizontal,
              actionSpacing: 4,
              actionTextStyle: TextStyle(fontSize: 18),
              primaryActionTextColor: ColorTokens.warning,
              titleSecondaryAction: 'Back',
              titlePrimaryAction: 'Save',
              useSafeArea: false,
              child: AppText(text: 'Sheet body'),
            ),
          ),
        );

        final footerRow = find.byWidgetPredicate(
          (widget) =>
              widget is Row &&
              widget.children.whereType<Expanded>().length == 2,
        );
        final saveText = tester.widget<Text>(find.text('Save'));

        expect(footerRow, findsOneWidget);
        expect(saveText.style?.fontSize, 18);
        expect(saveText.style?.color, ColorTokens.warning);
      },
    );

    testWidgets('static show displays and closes the bottom sheet', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder:
                (context) => Scaffold(
                  body: AppButton(
                    text: 'Open',
                    onPressed: () {
                      AppBottomSheet.show<void>(
                        context: context,
                        builder:
                            (_) => const AppBottomSheet(
                              title: 'Shown sheet',
                              child: AppText(text: 'Shown body'),
                            ),
                      );
                    },
                  ),
                ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Shown sheet'), findsOneWidget);
      expect(find.text('Shown body'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Shown sheet'), findsNothing);
    });
  });
}
