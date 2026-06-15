import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppStepper', () {
    testWidgets('renders initial value', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppStepper(
            value: 5,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, '5');
    });

    testWidgets('increments value and calls onChanged', (tester) async {
      int? updatedValue;
      await tester.pumpWidget(
        buildApp(
          AppStepper(
            value: 5,
            onChanged: (v) => updatedValue = v,
          ),
        ),
      );

      // Icon for "+" is Icons.add
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(updatedValue, 6);
    });

    testWidgets('decrements value and calls onChanged', (tester) async {
      int? updatedValue;
      await tester.pumpWidget(
        buildApp(
          AppStepper(
            value: 5,
            onChanged: (v) => updatedValue = v,
          ),
        ),
      );

      // Icon for "-" is Icons.remove
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(updatedValue, 4);
    });

    testWidgets('respects min constraint', (tester) async {
      int? updatedValue;
      await tester.pumpWidget(
        buildApp(
          AppStepper(
            value: 1,
            min: 1,
            onChanged: (v) => updatedValue = v,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Since min is 1 and current is 1, decrement should not fire onChanged
      expect(updatedValue, isNull);
    });

    testWidgets('respects max constraint', (tester) async {
      int? updatedValue;
      await tester.pumpWidget(
        buildApp(
          AppStepper(
            value: 5,
            max: 5,
            onChanged: (v) => updatedValue = v,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Since max is 5 and current is 5, increment should not fire onChanged
      expect(updatedValue, isNull);
    });

    testWidgets('supports keyboard input when allowKeyboardInput is true', (tester) async {
      int? updatedValue;
      await tester.pumpWidget(
        buildApp(
          AppStepper(
            value: 5,
            allowKeyboardInput: true,
            onChanged: (v) => updatedValue = v,
          ),
        ),
      );

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, '12');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(updatedValue, 12);
    });

    testWidgets('does not show TextField when allowKeyboardInput is false', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppStepper(
            value: 5,
            allowKeyboardInput: false,
            onChanged: (_) {},
          ),
        ),
      );

      // If allowKeyboardInput is false, we render an AppText inside the Center widget
      expect(find.byType(TextField), findsNothing);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('respects step option', (tester) async {
      int? updatedValue;
      await tester.pumpWidget(
        buildApp(
          AppStepper(
            value: 5,
            step: 3,
            onChanged: (v) => updatedValue = v,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(updatedValue, 8);
    });
  });
}
