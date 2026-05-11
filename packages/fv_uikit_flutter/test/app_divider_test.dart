import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppDivider', () {
    testWidgets('renders horizontal divider by default', (tester) async {
      await tester.pumpWidget(buildApp(const AppDivider()));

      final divider = tester.widget<Divider>(find.byType(Divider));

      expect(find.byType(VerticalDivider), findsNothing);
      expect(divider.thickness, 2);
      expect(divider.color, ColorTokens.borderDefault);
    });

    testWidgets('maps info variant to primary border color', (tester) async {
      await tester.pumpWidget(
        buildApp(const AppDivider(variant: AppDividerVariant.info)),
      );

      final divider = tester.widget<Divider>(find.byType(Divider));

      expect(divider.color, ColorTokens.primaryBorder);
    });

    testWidgets('renders vertical divider when configured', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppDivider(
            orientation: AppDividerOrientation.vertical,
            variant: AppDividerVariant.success,
          ),
        ),
      );

      final divider = tester.widget<VerticalDivider>(
        find.byType(VerticalDivider),
      );

      expect(find.byType(Divider), findsNothing);
      expect(divider.thickness, 2);
      expect(divider.color, ColorTokens.successBorderHover);
    });

    testWidgets('uses custom color thickness and length', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppDivider(
            color: ColorTokens.purple,
            thickness: 4,
            length: 120,
          ),
        ),
      );

      final divider = tester.widget<Divider>(find.byType(Divider));
      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(Divider),
          matching: find.byType(SizedBox),
        ),
      );

      expect(divider.color, ColorTokens.purple);
      expect(divider.thickness, 4);
      expect(sizedBox.width, 120);
    });
  });
}
