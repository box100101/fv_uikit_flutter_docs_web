import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  AnimatedContainer switchTrack(WidgetTester tester) {
    return tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
  }

  Color trackColor(WidgetTester tester) {
    final decoration = switchTrack(tester).decoration! as BoxDecoration;
    return decoration.color!;
  }

  group('AppSwitch', () {
    testWidgets('renders label and toggles when tapped', (tester) async {
      var value = false;

      await tester.pumpWidget(
        buildApp(
          AppSwitch(
            value: value,
            label: 'Switch label',
            onChanged: (nextValue) {
              value = nextValue;
            },
          ),
        ),
      );

      expect(find.text('Switch label'), findsOneWidget);

      await tester.tap(find.text('Switch label'));
      await tester.pump();

      expect(value, isTrue);
    });

    testWidgets('maps xSmall metrics from the Figma size set', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppSwitch(
            value: true,
            size: AppSwitchSize.xSmall,
            label: 'Switch label',
            onChanged: (_) {},
          ),
        ),
      );

      final trackSize = tester.getSize(find.byType(AnimatedContainer));
      final label = tester.widget<Text>(find.text('Switch label'));

      expect(trackSize.width, 20);
      expect(trackSize.height, 10);
      expect(label.style?.fontSize, TextStyleTokens.bodyXSRegular.fontSize);
    });

    testWidgets('maps xLarge metrics from the Figma size set', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppSwitch(
            value: true,
            size: AppSwitchSize.xLarge,
            label: 'Switch label',
            onChanged: (_) {},
          ),
        ),
      );

      final trackSize = tester.getSize(find.byType(AnimatedContainer));
      final label = tester.widget<Text>(find.text('Switch label'));

      expect(trackSize.width, 44);
      expect(trackSize.height, 24);
      expect(label.style?.fontSize, TextStyleTokens.bodyXLRegular.fontSize);
    });

    testWidgets('uses disabled active color and blocks interaction', (
      tester,
    ) async {
      var value = true;

      await tester.pumpWidget(
        buildApp(
          AppSwitch(
            value: value,
            label: 'Switch label',
            isDisabled: true,
            onChanged: (nextValue) {
              value = nextValue;
            },
          ),
        ),
      );

      expect(trackColor(tester), ColorTokens.borderOutline);

      await tester.tap(find.text('Switch label'));
      await tester.pump();

      expect(value, isTrue);
    });

    testWidgets('places label before the control when configured', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppSwitch(
            value: true,
            label: 'Left label',
            labelPosition: AppSwitchLabelPosition.left,
            onChanged: (_) {},
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.first, isA<AppText>());
    });
  });
}
