import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  Widget buildShowApp({
    required void Function(BuildContext context) onShow,
    Widget? child,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder:
              (context) => Center(
                child:
                    child ??
                    ElevatedButton(
                      onPressed: () => onShow(context),
                      child: const Text('Show alert'),
                    ),
              ),
        ),
      ),
    );
  }

  Color containerColor(WidgetTester tester) {
    final container = tester.widget<Container>(find.byType(Container).last);
    final decoration = container.decoration! as BoxDecoration;

    return decoration.color!;
  }

  Color iconColor(WidgetTester tester, IconData icon) {
    final iconThemeFinder = find.ancestor(
      of: find.byIcon(icon),
      matching: find.byType(IconTheme),
    );

    return tester.widget<IconTheme>(iconThemeFinder.first).data.color!;
  }

  IconThemeData iconThemeData(WidgetTester tester, IconData icon) {
    final iconThemeFinder = find.ancestor(
      of: find.byIcon(icon),
      matching: find.byType(IconTheme),
    );

    return tester.widget<IconTheme>(iconThemeFinder.first).data;
  }

  group('AppAlert', () {
    testWidgets('renders title, description, actions, and close icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const AppAlert(
            title: 'Alert title',
            description: 'Description',
            actions: [
              AppAlertAction(text: 'Action 1'),
              AppAlertAction(text: 'Action 2'),
            ],
          ),
        ),
      );

      expect(find.text('Alert title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('maps type to Figma background and icon color', (tester) async {
      final cases = [
        (
          type: AppAlertType.fallback,
          icon: Icons.info,
          expectedBackground: ColorTokens.white,
          expectedIcon: const Color(0xFF8C8C8C),
        ),
        (
          type: AppAlertType.info,
          icon: Icons.info,
          expectedBackground: const Color(0xFFE6F1FB),
          expectedIcon: ColorTokens.primary,
        ),
        (
          type: AppAlertType.warning,
          icon: Icons.error,
          expectedBackground: const Color(0xFFFFF5EB),
          expectedIcon: ColorTokens.warning,
        ),
        (
          type: AppAlertType.danger,
          icon: Icons.cancel,
          expectedBackground: const Color(0xFFFFF0F1),
          expectedIcon: ColorTokens.danger,
        ),
        (
          type: AppAlertType.success,
          icon: Icons.check_circle,
          expectedBackground: const Color(0xFFEFFFF4),
          expectedIcon: ColorTokens.successDefault,
        ),
      ];

      for (final testCase in cases) {
        await tester.pumpWidget(
          buildApp(AppAlert(type: testCase.type, title: 'Alert title')),
        );

        expect(containerColor(tester), testCase.expectedBackground);
        expect(iconColor(tester, testCase.icon), testCase.expectedIcon);
      }
    });

    testWidgets('maps size to spacing, icon size, and typography', (
      tester,
    ) async {
      final cases = [
        (
          size: AppAlertSize.xSmall,
          expectedPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          expectedIconSize: IconSizeTokens.iconSizeES,
          expectedTitleSize: TextStyleTokens.bodyXSMedium.fontSize,
          expectedDescriptionSize: TextStyleTokens.bodyXSRegular.fontSize,
          expectedActionSize: TextStyleTokens.bodyXSMedium.fontSize,
        ),
        (
          size: AppAlertSize.xLarge,
          expectedPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          expectedIconSize: IconSizeTokens.iconSize2XL,
          expectedTitleSize: TextStyleTokens.bodyXLMedium.fontSize,
          expectedDescriptionSize: TextStyleTokens.bodyXLRegular.fontSize,
          expectedActionSize: TextStyleTokens.bodyXLMedium.fontSize,
        ),
      ];

      for (final testCase in cases) {
        await tester.pumpWidget(
          buildApp(
            AppAlert(
              size: testCase.size,
              title: 'Alert title',
              description: 'Description',
              actions: const [AppAlertAction(text: 'Action 1')],
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container).last);
        final title = tester.widget<Text>(find.text('Alert title'));
        final description = tester.widget<Text>(find.text('Description'));
        final action = tester.widget<Text>(find.text('Action 1'));

        expect(container.padding, testCase.expectedPadding);
        expect(
          iconThemeData(tester, Icons.info).size,
          testCase.expectedIconSize,
        );
        expect(title.style?.fontSize, testCase.expectedTitleSize);
        expect(description.style?.fontSize, testCase.expectedDescriptionSize);
        expect(action.style?.fontSize, testCase.expectedActionSize);
      }
    });

    testWidgets('triggers action callbacks', (tester) async {
      var actionCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppAlert(
            title: 'Alert title',
            actions: [
              AppAlertAction(
                text: 'Action 1',
                onPressed: () => actionCount += 1,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Action 1'));
      await tester.pump();

      expect(actionCount, 1);
    });

    testWidgets('dismisses itself when close is tapped', (tester) async {
      var closeCount = 0;
      var closedCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppAlert(
            title: 'Alert title',
            animationDuration: Duration.zero,
            onClose: () => closeCount += 1,
            onClosed: () => closedCount += 1,
          ),
        ),
      );

      expect(find.text('Alert title'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Alert title'), findsNothing);
      expect(closeCount, 1);
      expect(closedCount, 1);
    });

    testWidgets('can keep rendering when close is externally controlled', (
      tester,
    ) async {
      var closeCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppAlert(
            title: 'Alert title',
            dismissible: false,
            onClose: () => closeCount += 1,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(closeCount, 1);
      expect(find.text('Alert title'), findsOneWidget);
    });

    testWidgets('respects controlled visible updates', (tester) async {
      Widget buildControlled(bool visible) {
        return buildApp(
          AppAlert(
            title: 'Alert title',
            visible: visible,
            animationDuration: Duration.zero,
          ),
        );
      }

      await tester.pumpWidget(buildControlled(false));
      await tester.pumpAndSettle();

      expect(find.text('Alert title'), findsNothing);

      await tester.pumpWidget(buildControlled(true));
      await tester.pumpAndSettle();

      expect(find.text('Alert title'), findsOneWidget);
    });

    testWidgets('shows and closes through static methods', (tester) async {
      AppAlertController? controller;
      var closedCount = 0;

      await tester.pumpWidget(
        buildShowApp(
          onShow: (context) {
            controller = AppAlert.show(
              context: context,
              title: 'Overlay alert',
              animationDuration: Duration.zero,
              onClosed: () => closedCount += 1,
            );
          },
        ),
      );

      await tester.tap(find.text('Show alert'));
      await tester.pumpAndSettle();

      expect(find.text('Overlay alert'), findsOneWidget);
      expect(controller?.isOpen, isTrue);

      AppAlert.close(controller!);
      await tester.pumpAndSettle();

      expect(find.text('Overlay alert'), findsNothing);
      expect(controller?.isOpen, isFalse);
      expect(closedCount, 1);
    });

    testWidgets('show close button dismisses overlay alert', (tester) async {
      var closeCount = 0;
      var closedCount = 0;

      await tester.pumpWidget(
        buildShowApp(
          onShow: (context) {
            AppAlert.show(
              context: context,
              title: 'Overlay alert',
              animationDuration: Duration.zero,
              onClose: () => closeCount += 1,
              onClosed: () => closedCount += 1,
            );
          },
        ),
      );

      await tester.tap(find.text('Show alert'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Overlay alert'), findsNothing);
      expect(closeCount, 1);
      expect(closedCount, 1);
    });

    testWidgets('supports placement and offset for overlay alerts', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildShowApp(
          onShow: (context) {
            AppAlert.show(
              context: context,
              title: 'Bottom alert',
              placement: AppAlertPlacement.bottom,
              offset: const Offset(0, -24),
              animationDuration: Duration.zero,
            );
          },
        ),
      );

      await tester.tap(find.text('Show alert'));
      await tester.pumpAndSettle();

      final alignFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Align && widget.alignment == Alignment.bottomCenter,
      );

      expect(find.text('Bottom alert'), findsOneWidget);
      expect(alignFinder, findsOneWidget);
    });

    testWidgets('supports absolute overlay positioning', (tester) async {
      await tester.pumpWidget(
        buildShowApp(
          onShow: (context) {
            AppAlert.show(
              context: context,
              title: 'Positioned alert',
              top: 24,
              right: 16,
              animationDuration: Duration.zero,
            );
          },
        ),
      );

      await tester.tap(find.text('Show alert'));
      await tester.pumpAndSettle();

      final positionedFinder = find.ancestor(
        of: find.text('Positioned alert'),
        matching: find.byType(Positioned),
      );
      final positioned = tester.widget<Positioned>(positionedFinder.first);

      expect(positioned.top, 24);
      expect(positioned.right, 16);
    });

    testWidgets('shows from root overlay above constrained parents', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Builder(
                  builder:
                      (context) => ElevatedButton(
                        onPressed: () {
                          AppAlert.show(
                            context: context,
                            title: 'Root overlay alert',
                            animationDuration: Duration.zero,
                          );
                        },
                        child: const Text('Show'),
                      ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final overlayPositionedFinder = find.ancestor(
        of: find.text('Root overlay alert'),
        matching: find.byWidgetPredicate(
          (widget) => widget is Positioned && widget.top == 0,
        ),
      );
      final alertSize = tester.getSize(find.text('Root overlay alert'));

      expect(find.text('Root overlay alert'), findsOneWidget);
      expect(overlayPositionedFinder, findsOneWidget);
      expect(alertSize.width, greaterThan(48));
    });

    testWidgets('does not block taps outside the alert bounds', (tester) async {
      var behindTapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (behindTapCount == 0) {
                          AppAlert.show(
                            context: context,
                            title: 'Non blocking alert',
                            animationDuration: Duration.zero,
                          );
                        }
                        behindTapCount += 1;
                      },
                      child: const Text('Behind button'),
                    ),
                  ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Behind button'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Behind button'));
      await tester.pump();

      expect(find.text('Non blocking alert'), findsOneWidget);
      expect(behindTapCount, 2);
    });
  });
}
