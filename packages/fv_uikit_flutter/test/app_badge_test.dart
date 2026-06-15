import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  DecoratedBox decoratedBadge(WidgetTester tester) {
    return tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(AppBadge),
        matching: find.byType(DecoratedBox),
      ),
    );
  }

  group('AppBadge', () {
    testWidgets('renders text with leading icon', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppBadge(
            text: 'Verified account',
            variant: AppBadgeVariant.info,
            leading: Icon(Icons.check_rounded),
          ),
        ),
      );

      expect(find.text('Verified account'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('uses medium badge size and medium bold text by default', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(const AppBadge(text: 'Default badge')));

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(AppBadge),
          matching: find.byType(Padding),
        ),
      );
      final text = tester.widget<Text>(find.byType(Text).first);

      expect(
        padding.padding,
        const EdgeInsets.symmetric(
          horizontal: SpacingTokens.paddingL,
          vertical: SpacingTokens.yPaddingM,
        ),
      );
      expect(text.style?.fontSize, TextStyleTokens.bodyMBold.fontSize);
      expect(text.style?.fontWeight, TextStyleTokens.bodyMBold.fontWeight);
    });

    testWidgets('maps success variant colors', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppBadge(
            text: 'Profile completed',
            variant: AppBadgeVariant.success,
          ),
        ),
      );

      final decoration = decoratedBadge(tester).decoration as BoxDecoration;
      final text = tester.widget<Text>(find.byType(Text).first);

      expect(decoration.color, ColorTokens.successBg);
      expect(text.style?.color, ColorTokens.successActive);
    });

    testWidgets('supports custom text style and spacing metrics', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppBadge(
            text: '+12.5%',
            size: AppBadgeSize.xLarge,
            textSize: AppTextSize.heading4Bold,
            leading: const Icon(Icons.trending_up_rounded),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            gap: 14,
            textStyle: TextStyleTokens.heading4Bold,
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(AppBadge),
          matching: find.byType(Padding),
        ),
      );
      final spacer = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 14,
        ),
      );
      final text = tester.widget<Text>(find.byType(Text).first);

      expect(
        padding.padding,
        const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      );
      expect(spacer.width, 14);
      expect(text.style?.fontSize, TextStyleTokens.heading4Bold.fontSize);
      expect(text.style?.fontWeight, TextStyleTokens.heading4Bold.fontWeight);
    });

    testWidgets('scales badge metrics from AppBadgeSize', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppBadge(
            text: 'New',
            size: AppBadgeSize.xSmall,
            leading: Icon(Icons.fiber_new_rounded),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(AppBadge),
          matching: find.byType(Padding),
        ),
      );

      expect(
        padding.padding,
        const EdgeInsets.symmetric(
          horizontal: SpacingTokens.paddingS,
          vertical: SpacingTokens.yPaddingXS,
        ),
      );
    });

    testWidgets('supports custom radius override', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppBadge(text: 'Rounded', radius: RadiusTokens.radiusL)),
      );

      final decoration = decoratedBadge(tester).decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius! as BorderRadius;

      expect(borderRadius.topLeft.x, RadiusTokens.radiusL);
      expect(borderRadius.topRight.x, RadiusTokens.radiusL);
    });
  });
}
