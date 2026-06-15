import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  AnimatedContainer checkboxControl(WidgetTester tester) {
    return tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
  }

  BoxDecoration controlDecoration(WidgetTester tester) {
    return checkboxControl(tester).decoration! as BoxDecoration;
  }

  group('AppCheckbox', () {
    testWidgets('renders label and toggles when tapped', (tester) async {
      bool? value = false;

      await tester.pumpWidget(
        buildApp(
          AppCheckbox(
            value: value,
            label: 'Checkbox label',
            onChanged: (nextValue) {
              value = nextValue;
            },
          ),
        ),
      );

      expect(find.text('Checkbox label'), findsOneWidget);

      await tester.tap(find.text('Checkbox label'));
      await tester.pump();

      expect(value, isTrue);
    });

    testWidgets('cycles null state when tristate is enabled', (tester) async {
      bool? value = true;

      await tester.pumpWidget(
        buildApp(
          AppCheckbox(
            value: value,
            label: 'Checkbox label',
            tristate: true,
            onChanged: (nextValue) {
              value = nextValue;
            },
          ),
        ),
      );

      await tester.tap(find.text('Checkbox label'));
      await tester.pump();

      expect(value, isNull);
    });

    testWidgets('maps xSmall metrics from the Figma size set', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppCheckbox(
            value: true,
            size: AppCheckboxSize.xSmall,
            label: 'Checkbox label',
            onChanged: (_) {},
          ),
        ),
      );

      final controlSize = tester.getSize(find.byType(AnimatedContainer).first);
      final label = tester.widget<Text>(find.text('Checkbox label'));

      expect(controlSize.width, 12);
      expect(controlSize.height, 12);
      expect(label.style?.fontSize, TextStyleTokens.bodyXSRegular.fontSize);
    });

    testWidgets('maps xLarge metrics from the Figma size set', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppCheckbox(
            value: true,
            size: AppCheckboxSize.xLarge,
            label: 'Checkbox label',
            onChanged: (_) {},
          ),
        ),
      );

      final controlSize = tester.getSize(find.byType(AnimatedContainer).first);
      final label = tester.widget<Text>(find.text('Checkbox label'));

      expect(controlSize.width, 26);
      expect(controlSize.height, 26);
      expect(label.style?.fontSize, TextStyleTokens.bodyXLRegular.fontSize);
    });

    testWidgets('uses active color when checked', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppCheckbox(value: true, label: 'Checked label', onChanged: (_) {}),
        ),
      );

      expect(controlDecoration(tester).color, ColorTokens.primary);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('uses minus mark when indeterminate', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppCheckbox(
            value: null,
            label: 'Mixed label',
            tristate: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgets('blocks disabled interaction and dims label', (tester) async {
      bool? value = false;

      await tester.pumpWidget(
        buildApp(
          AppCheckbox(
            value: value,
            label: 'Disabled label',
            isDisabled: true,
            onChanged: (nextValue) {
              value = nextValue;
            },
          ),
        ),
      );

      final label = tester.widget<Text>(find.text('Disabled label'));

      expect(label.style?.color, ColorTokens.textDisabled);

      await tester.tap(find.text('Disabled label'));
      await tester.pump();

      expect(value, isFalse);
    });

    testWidgets('renders boxed variant with border container', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppCheckbox(
            value: true,
            label: 'Boxed label',
            variant: AppCheckboxVariant.boxed,
            onChanged: (_) {},
          ),
        ),
      );

      final boxedContainer = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = boxedContainer.decoration! as BoxDecoration;

      expect(decoration.color, ColorTokens.white);
      expect(decoration.border, isA<Border>());
    });

    testWidgets('renders selectbox variant with corner check', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppCheckbox(
            value: true,
            label: 'Selectbox label',
            variant: AppCheckboxVariant.selectbox,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Selectbox label'), findsOneWidget);
      expect(find.byType(Positioned), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);

      final corner = find.ancestor(
        of: find.byIcon(Icons.check),
        matching: find.byType(AnimatedContainer),
      );
      final selectbox = find.ancestor(of: corner, matching: find.byType(Stack));

      expect(tester.getTopRight(corner), tester.getTopRight(selectbox));
    });

    testWidgets('places label before the control when configured', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppCheckbox(
            value: true,
            label: 'Left label',
            labelPosition: AppCheckboxLabelPosition.left,
            onChanged: (_) {},
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.first, isA<AppText>());
    });
  });
}
