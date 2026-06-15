import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppNumpad', () {
    testWidgets('renders all keys', (tester) async {
      final controller = TextEditingController(text: '');
      await tester.pumpWidget(
        buildApp(
          AppNumpad(
            controller: controller,
          ),
        ),
      );

      // Verify some standard keys exist
      expect(find.text('1'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('000'), findsOneWidget);
      expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);
    });

    testWidgets('presses number keys to append value', (tester) async {
      final controller = TextEditingController(text: '');
      String? updatedValue;
      await tester.pumpWidget(
        buildApp(
          AppNumpad(
            controller: controller,
            onChanged: (v) => updatedValue = v,
          ),
        ),
      );

      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      expect(controller.text, '1');
      expect(updatedValue, '1');

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();
      expect(controller.text, '15');
      expect(updatedValue, '15');

      await tester.tap(find.text('000'));
      await tester.pumpAndSettle();
      expect(controller.text, '15000');
      expect(updatedValue, '15000');
    });

    testWidgets('presses backspace to delete last character', (tester) async {
      final controller = TextEditingController(text: '123');
      String? updatedValue;
      await tester.pumpWidget(
        buildApp(
          AppNumpad(
            controller: controller,
            onChanged: (v) => updatedValue = v,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pumpAndSettle();
      expect(controller.text, '12');
      expect(updatedValue, '12');

      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pumpAndSettle();
      expect(controller.text, '1');
      expect(updatedValue, '1');

      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pumpAndSettle();
      expect(controller.text, '');
      expect(updatedValue, '');
    });

    testWidgets('respects max value constraint', (tester) async {
      final controller = TextEditingController(text: '90');
      await tester.pumpWidget(
        buildApp(
          AppNumpad(
            controller: controller,
            maxValue: 99,
          ),
        ),
      );

      await tester.tap(find.text('9'));
      await tester.pumpAndSettle();

      // Typing 9 would make it 909, but clamped to maxValue (99)
      expect(controller.text, '99');
    });

    testWidgets('renders display header when showDisplayHeader is true', (tester) async {
      final controller = TextEditingController(text: '9541');
      await tester.pumpWidget(
        buildApp(
          AppNumpad(
            controller: controller,
            showDisplayHeader: true,
            headerTitle: 'Số tiền trả khách',
            headerAmount: 9541,
            headerSubtitle: 'Khách cần trả lại',
            headerSubtitleValue: 0,
            currencyUnit: 'đ',
          ),
        ),
      );

      expect(find.text('Số tiền trả khách'), findsOneWidget);
      expect(find.text('9,541 đ'), findsOneWidget);
      expect(find.text('Khách cần trả lại'), findsOneWidget);
      expect(find.text('0 đ'), findsOneWidget);
    });
  });
}
