import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  AnimatedContainer radioControl(WidgetTester tester) {
    return tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
  }

  BoxDecoration controlDecoration(WidgetTester tester) {
    return radioControl(tester).decoration! as BoxDecoration;
  }

  group('AppRadio', () {
    testWidgets('renders label and selects value when tapped', (tester) async {
      var selectedValue = 'one';

      await tester.pumpWidget(
        buildApp(
          AppRadio<String>(
            value: 'two',
            groupValue: selectedValue,
            label: 'Radiobox label',
            onChanged: (value) {
              selectedValue = value!;
            },
          ),
        ),
      );

      expect(find.text('Radiobox label'), findsOneWidget);

      await tester.tap(find.text('Radiobox label'));
      await tester.pump();

      expect(selectedValue, 'two');
    });

    testWidgets('maps xSmall metrics from the Figma size set', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppRadio<String>(
            value: 'one',
            groupValue: 'one',
            size: AppRadioSize.xSmall,
            label: 'Radiobox label',
            onChanged: (_) {},
          ),
        ),
      );

      final controlSize = tester.getSize(find.byType(AnimatedContainer).first);
      final label = tester.widget<Text>(find.text('Radiobox label'));

      expect(controlSize.width, 12);
      expect(controlSize.height, 12);
      expect(label.style?.fontSize, TextStyleTokens.bodyXSRegular.fontSize);
    });

    testWidgets('maps xLarge metrics from the Figma size set', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppRadio<String>(
            value: 'one',
            groupValue: 'one',
            size: AppRadioSize.xLarge,
            label: 'Radiobox label',
            onChanged: (_) {},
          ),
        ),
      );

      final controlSize = tester.getSize(find.byType(AnimatedContainer).first);
      final label = tester.widget<Text>(find.text('Radiobox label'));

      expect(controlSize.width, 24);
      expect(controlSize.height, 24);
      expect(label.style?.fontSize, TextStyleTokens.bodyXLRegular.fontSize);
    });

    testWidgets('uses active border color when selected', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppRadio<String>(
            value: 'one',
            groupValue: 'one',
            label: 'Selected label',
            onChanged: (_) {},
          ),
        ),
      );

      expect(controlDecoration(tester).border, isA<Border>());
      final border = controlDecoration(tester).border! as Border;
      expect(border.top.color, ColorTokens.primary);
    });

    testWidgets('blocks disabled interaction and dims label', (tester) async {
      var selectedValue = 'one';

      await tester.pumpWidget(
        buildApp(
          AppRadio<String>(
            value: 'two',
            groupValue: selectedValue,
            label: 'Disabled label',
            isDisabled: true,
            onChanged: (value) {
              selectedValue = value!;
            },
          ),
        ),
      );

      final label = tester.widget<Text>(find.text('Disabled label'));

      expect(label.style?.color, ColorTokens.textDisabled);

      await tester.tap(find.text('Disabled label'));
      await tester.pump();

      expect(selectedValue, 'one');
    });

    testWidgets('renders boxed variant with border container', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppRadio<String>(
            value: 'one',
            groupValue: 'one',
            label: 'Boxed label',
            variant: AppRadioVariant.boxed,
            onChanged: (_) {},
          ),
        ),
      );

      final boxedContainer = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Boxed label'),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container &&
                    widget.decoration is BoxDecoration &&
                    (widget.decoration! as BoxDecoration).border != null,
              ),
            )
            .first,
      );
      final decoration = boxedContainer.decoration! as BoxDecoration;

      expect(decoration.color, ColorTokens.white);
      expect(decoration.border, isA<Border>());
    });

    testWidgets('places label before the control when configured', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppRadio<String>(
            value: 'one',
            groupValue: 'one',
            label: 'Left label',
            labelPosition: AppRadioLabelPosition.left,
            onChanged: (_) {},
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.first, isA<AppText>());
    });
  });
}
