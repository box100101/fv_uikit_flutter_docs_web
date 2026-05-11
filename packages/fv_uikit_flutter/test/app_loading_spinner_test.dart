import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppLoadingSpinner', () {
    testWidgets('renders token-based defaults', (tester) async {
      await tester.pumpWidget(buildApp(const AppLoadingSpinner()));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(sizedBox.width, IconSizeTokens.iconSizeL);
      expect(sizedBox.height, IconSizeTokens.iconSizeL);
      expect(indicator.strokeWidth, 2);
      expect(indicator.color, ColorTokens.primaryDefault);
    });

    testWidgets('applies custom props', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppLoadingSpinner(
            size: 32,
            strokeWidth: 3,
            color: ColorTokens.dangerDefault,
            backgroundColor: ColorTokens.borderSecondary,
            value: 0.5,
            padding: EdgeInsets.all(8),
            semanticsLabel: 'Submitting',
            semanticsValue: '50',
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(padding.padding, const EdgeInsets.all(8));
      expect(sizedBox.width, 32);
      expect(sizedBox.height, 32);
      expect(indicator.strokeWidth, 3);
      expect(indicator.color, ColorTokens.dangerDefault);
      expect(indicator.backgroundColor, ColorTokens.borderSecondary);
      expect(indicator.value, 0.5);
      expect(indicator.semanticsLabel, 'Submitting');
      expect(indicator.semanticsValue, '50');
    });
  });
}
