import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppSkeleton', () {
    testWidgets('renders rectangle metrics and radius overrides', (
      tester,
    ) async {
      const borderRadius = BorderRadius.all(Radius.circular(12));

      await tester.pumpWidget(
        buildApp(
          const AppSkeleton(
            width: 120,
            height: 20,
            borderRadius: borderRadius,
            isAnimated: false,
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final decoration = decoratedBox.decoration as BoxDecoration;

      expect(sizedBox.width, 120);
      expect(sizedBox.height, 20);
      expect(decoration.shape, BoxShape.rectangle);
      expect(decoration.borderRadius, borderRadius);
      expect(decoration.color, ColorTokens.borderSecondary);
    });

    testWidgets('renders circle skeleton as a square shimmer block', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const AppSkeleton(
            width: 40,
            shape: BoxShape.circle,
            isAnimated: false,
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final decoration = decoratedBox.decoration as BoxDecoration;

      expect(sizedBox.width, 40);
      expect(sizedBox.height, 40);
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.borderRadius, isNull);
    });

    testWidgets('uses animated gradient shimmer by default', (tester) async {
      await tester.pumpWidget(buildApp(const AppSkeleton(width: 120)));

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byType(DecoratedBox),
      );
      final decoration = decoratedBox.decoration as BoxDecoration;

      expect(decoration.gradient, isA<LinearGradient>());
      expect(decoration.color, isNull);
    });
  });

  group('Loading', () {
    testWidgets('wraps AppLoadingSpinner with compatibility defaults', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(const Loading(isAnimated: false)));

      final spinner = tester.widget<AppLoadingSpinner>(
        find.byType(AppLoadingSpinner),
      );

      expect(spinner.size, IconSizeTokens.iconSizeL);
      expect(spinner.strokeWidth, 2);
      expect(spinner.color, isNull);
    });
  });
}
