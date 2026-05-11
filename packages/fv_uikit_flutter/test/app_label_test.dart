import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  Text richLabel(WidgetTester tester) {
    return tester.widget<Text>(find.byType(Text).first);
  }

  String plainText(WidgetTester tester) {
    return richLabel(tester).textSpan!.toPlainText();
  }

  group('AppLabel', () {
    testWidgets('renders label with required marker and optional text', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const AppLabel(
            text: 'Label content',
            isRequired: true,
            isOptional: true,
          ),
        ),
      );

      expect(plainText(tester), 'Label content * (optional)');
    });

    testWidgets('supports required markers on both sides', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppLabel(
            text: 'Label content',
            isRequired: true,
            requiredPosition: AppLabelRequiredPosition.both,
          ),
        ),
      );

      expect(plainText(tester), '* Label content *');
    });

    testWidgets('maps xLarge metrics from the Figma size set', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppLabel(
            text: 'Label content',
            size: AppLabelSize.xLarge,
            showInfoIcon: true,
          ),
        ),
      );

      final label = richLabel(tester);
      final iconSlot = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byIcon(Icons.info_outline),
          matching: find.byType(SizedBox),
        ),
      );

      expect(
        label.textSpan?.style?.fontSize,
        TextStyleTokens.bodyXLBold.fontSize,
      );
      expect(iconSlot.width, 26);
      expect(iconSlot.height, 26);
    });

    testWidgets('uses custom optional text and handles info tap', (
      tester,
    ) async {
      var tapCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppLabel(
            text: 'Label content',
            isOptional: true,
            optionalText: '(custom optional)',
            showInfoIcon: true,
            onInfoTap: () {
              tapCount += 1;
            },
          ),
        ),
      );

      expect(plainText(tester), 'Label content (custom optional)');

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pump();

      expect(tapCount, 1);
    });
  });
}
