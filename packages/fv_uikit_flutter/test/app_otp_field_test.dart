import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppOtpField', () {
    testWidgets('renders six OTP cells by default', (tester) async {
      await tester.pumpWidget(buildApp(const AppOtpField()));

      for (var index = 0; index < 6; index += 1) {
        expect(
          find.byKey(ValueKey('app-otp-field-cell-$index')),
          findsOneWidget,
        );
      }
    });

    testWidgets('focuses the hidden input when tapping the widget', (
      tester,
    ) async {
      final focusNode = FocusNode();

      addTearDown(focusNode.dispose);

      await tester.pumpWidget(buildApp(AppOtpField(focusNode: focusNode)));

      expect(focusNode.hasFocus, isFalse);

      await tester.tap(find.byKey(const ValueKey('app-otp-field-tap-target')));
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('publishes sanitized digits and completion callback', (
      tester,
    ) async {
      final controller = TextEditingController();
      final changedValues = <String>[];
      String? completedValue;

      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          AppOtpField(
            controller: controller,
            onChanged: changedValues.add,
            onCompleted: (value) {
              completedValue = value;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '12a34b567');
      await tester.pumpAndSettle();

      expect(controller.text, '123456');
      expect(changedValues, contains('123456'));
      expect(completedValue, '123456');
      expect(find.text('1'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
    });

    testWidgets('sanitizes an external controller value on first build', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'otp-12-34-56-78');

      addTearDown(controller.dispose);

      await tester.pumpWidget(buildApp(AppOtpField(controller: controller)));

      expect(controller.text, '123456');
      expect(find.text('1'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('7'), findsNothing);
    });
  });
}
