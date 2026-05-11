import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppButton', () {
    testWidgets('renders the label and triggers tap', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppButton(
            text: 'Tiếp tục',
            onPressed: () {
              tapCount += 1;
            },
          ),
        ),
      );

      expect(find.text('Tiếp tục'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(tapCount, 1);
    });

    testWidgets('shows loading indicator and disables tap while loading', (
      tester,
    ) async {
      var tapCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppButton(
            text: 'Đang gửi',
            isLoading: true,
            onPressed: () {
              tapCount += 1;
            },
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      expect(find.byType(AppLoadingSpinner), findsOneWidget);
      expect(find.text('Đang gửi'), findsOneWidget);
      expect(button.onPressed, isNull);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(tapCount, 0);
    });

    testWidgets('maps outline variant to border-first appearance', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            text: 'Xem chi tiết',
            variant: AppButtonVariant.outline,
            onPressed: () {},
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      expect(
        button.style?.side?.resolve(<WidgetState>{}),
        const BorderSide(color: ColorTokens.borderOutline),
      );
    });

    testWidgets('renders icons on both sides of the label', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppButton(
            text: 'Tạo mới',
            iconLeft: Icon(Icons.add),
            iconRight: Icon(Icons.arrow_forward),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('falls back to medium metrics when size is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(AppButton(text: 'Mặc định', size: null, onPressed: () {})),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      expect(
        button.style?.minimumSize?.resolve(<WidgetState>{}),
        const Size(0, 48),
      );
    });
  });
}
