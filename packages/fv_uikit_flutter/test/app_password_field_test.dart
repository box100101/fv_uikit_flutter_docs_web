import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppPasswordField', () {
    testWidgets('obscures text by default and toggles visibility', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const AppPasswordField(
            labelText: 'Mật khẩu',
            hintText: 'Nhập mật khẩu',
          ),
        ),
      );

      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);

      var textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
      expect(textField.keyboardType, TextInputType.visiblePassword);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isFalse);
    });

    testWidgets('hides clear action by default for password input', (
      tester,
    ) async {
      final controller = TextEditingController();

      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(AppPasswordField(controller: controller)),
      );

      await tester.enterText(find.byType(TextField), 'secret123');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.cancel_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('can opt in to the inherited clear action', (tester) async {
      final controller = TextEditingController();

      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          AppPasswordField(controller: controller, showClearTextAction: true),
        ),
      );

      await tester.enterText(find.byType(TextField), 'secret123');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    });
  });
}
