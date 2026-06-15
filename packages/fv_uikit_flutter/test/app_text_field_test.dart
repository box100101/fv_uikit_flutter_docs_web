import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  Color iconColor(WidgetTester tester, IconData icon) {
    final iconThemeFinder = find.ancestor(
      of: find.byIcon(icon),
      matching: find.byType(IconTheme),
    );

    return tester.widget<IconTheme>(iconThemeFinder.first).data.color!;
  }

  group('AppTextField size mapping', () {
    testWidgets(
      'maps xSmall content, affix, counter, supporting text, and icon sizing',
      (tester) async {
        final controller = TextEditingController(text: '12');

        addTearDown(controller.dispose);

        await tester.pumpWidget(
          buildApp(
            AppTextField(
              controller: controller,
              size: AppTextFieldSize.xSmall,
              prefix: const AppText(text: 'Prefix'),
              suffix: const AppText(text: 'Suffix'),
              prefixIcon: const Icon(Icons.search),
              helperText: 'Helper',
              maxLength: 20,
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        final prefixText = tester.widget<Text>(find.text('Prefix'));
        final suffixText = tester.widget<Text>(find.text('Suffix'));
        final counterText = tester.widget<Text>(find.text('2 / 20'));
        final helperText = tester.widget<Text>(find.text('Helper'));
        final container = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final iconThemes =
            tester
                .widgetList<IconTheme>(find.byType(IconTheme))
                .map((theme) => theme.data.size)
                .whereType<double>()
                .toList();

        expect(
          textField.style?.fontSize,
          TextStyleTokens.bodyXSRegular.fontSize,
        );
        expect(
          prefixText.style?.fontSize,
          TextStyleTokens.bodyXSRegular.fontSize,
        );
        expect(
          suffixText.style?.fontSize,
          TextStyleTokens.bodyXSRegular.fontSize,
        );
        expect(
          counterText.style?.fontSize,
          TextStyleTokens.bodyXSRegular.fontSize,
        );
        expect(
          helperText.style?.fontSize,
          TextStyleTokens.bodyXSRegular.fontSize,
        );
        expect(container.constraints?.minHeight, 32);
        expect(iconThemes, contains(16));
      },
    );

    testWidgets(
      'maps xLarge content, affix, counter, supporting text, and icon sizing',
      (tester) async {
        final controller = TextEditingController(text: 'abcd');

        addTearDown(controller.dispose);

        await tester.pumpWidget(
          buildApp(
            AppTextField(
              controller: controller,
              size: AppTextFieldSize.xLarge,
              prefix: const AppText(text: 'Prefix'),
              suffixIcon: const Icon(Icons.visibility),
              errorText: 'Error',
              maxLength: 20,
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        final prefixText = tester.widget<Text>(find.text('Prefix'));
        final counterText = tester.widget<Text>(find.text('4 / 20'));
        final errorText = tester.widget<Text>(find.text('Error'));
        final container = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final iconThemes =
            tester
                .widgetList<IconTheme>(find.byType(IconTheme))
                .map((theme) => theme.data.size)
                .whereType<double>()
                .toList();

        expect(
          textField.style?.fontSize,
          TextStyleTokens.bodyXLRegular.fontSize,
        );
        expect(
          prefixText.style?.fontSize,
          TextStyleTokens.bodyXLRegular.fontSize,
        );
        expect(
          counterText.style?.fontSize,
          TextStyleTokens.bodyXLRegular.fontSize,
        );
        expect(
          errorText.style?.fontSize,
          TextStyleTokens.bodyXLRegular.fontSize,
        );
        expect(container.constraints?.minHeight, 64);
        expect(iconThemes, contains(24));
      },
    );

    testWidgets('uses custom error text size when provided', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppTextField(
            errorText: 'Error',
            errorTextSize: AppTextSize.bodyXSRegular,
            size: AppTextFieldSize.xLarge,
          ),
        ),
      );

      final errorText = tester.widget<Text>(find.text('Error'));

      expect(errorText.style?.fontSize, TextStyleTokens.bodyXSRegular.fontSize);
    });

    testWidgets('does not apply error text size to helper text', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          const AppTextField(
            helperText: 'Helper',
            errorTextSize: AppTextSize.bodyXSRegular,
            size: AppTextFieldSize.xLarge,
          ),
        ),
      );

      final helperText = tester.widget<Text>(find.text('Helper'));

      expect(
        helperText.style?.fontSize,
        TextStyleTokens.bodyXLRegular.fontSize,
      );
    });
  });

  group('AppTextField behavior', () {
    testWidgets('counts grapheme clusters in the custom counter', (
      tester,
    ) async {
      final controller = TextEditingController(text: '👨‍👩‍👧‍👦');

      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(AppTextField(controller: controller, maxLength: 10)),
      );

      expect(find.text('1 / 10'), findsOneWidget);
    });

    testWidgets('shows auto label only when focused or filled', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildApp(
          AppTextField(
            controller: controller,
            focusNode: focusNode,
            labelText: 'Email',
            hintText: 'Enter email',
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
      );

      expect(find.text('Email'), findsNothing);
      expect(find.text('Enter email'), findsOneWidget);

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);

      focusNode.unfocus();
      controller.text = 'user@example.com';
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('tapping widget area focuses the text field', (tester) async {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        buildApp(
          AppTextField(
            controller: controller,
            focusNode: focusNode,
            labelText: 'Email',
            helperText: 'Helper',
          ),
        ),
      );

      expect(focusNode.hasFocus, isFalse);

      await tester.tap(find.text('Email'));
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('calls onTap when the field area is tapped', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(buildApp(AppTextField(onTap: () => tapCount++)));

      await tester.tap(find.byType(AppTextField));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
    });

    testWidgets('obscures text when configured as a password field', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(const AppTextField(isPassword: true, hintText: 'Password')),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.obscureText, isTrue);
    });

    testWidgets('maps prefix and suffix icon colors by variant', (
      tester,
    ) async {
      final cases = [
        (
          variant: AppTextFieldVariant.primary,
          expectedColor: ColorTokens.iconDefault,
        ),
        (
          variant: AppTextFieldVariant.danger,
          expectedColor: ColorTokens.dangerDefault,
        ),
        (
          variant: AppTextFieldVariant.warning,
          expectedColor: ColorTokens.warningDefault,
        ),
        (
          variant: AppTextFieldVariant.success,
          expectedColor: ColorTokens.successDefault,
        ),
      ];

      for (final testCase in cases) {
        await tester.pumpWidget(
          buildApp(
            AppTextField(
              variant: testCase.variant,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.visibility),
            ),
          ),
        );

        expect(iconColor(tester, Icons.search), testCase.expectedColor);
        expect(iconColor(tester, Icons.visibility), testCase.expectedColor);
      }
    });

    testWidgets('shows clear action only when the field has value', (
      tester,
    ) async {
      final controller = TextEditingController();
      final changedValues = <String>[];

      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          AppTextField(controller: controller, onChanged: changedValues.add),
        ),
      );

      expect(find.byIcon(Icons.cancel_outlined), findsNothing);

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pumpAndSettle();

      expect(controller.text, isEmpty);
      expect(find.byIcon(Icons.cancel_outlined), findsNothing);
      expect(changedValues, ['hello', '']);
    });

    testWidgets('uses custom clear text icon when provided', (tester) async {
      final controller = TextEditingController(text: 'hello');

      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          AppTextField(
            controller: controller,
            clearTextIcon: const Icon(Icons.close),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsNothing);
    });

    testWidgets('uses validate callback result as error text', (tester) async {
      final controller = TextEditingController(text: 'user@example.com');

      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildApp(
          AppTextField(
            controller: controller,
            validate:
                (value) => value.contains('@') ? null : 'Email không hợp lệ',
          ),
        ),
      );

      expect(find.text('Email không hợp lệ'), findsNothing);

      await tester.enterText(find.byType(TextField), 'invalid');
      await tester.pumpAndSettle();

      expect(find.text('Email không hợp lệ'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'valid@example.com');
      await tester.pumpAndSettle();

      expect(find.text('Email không hợp lệ'), findsNothing);
    });

    testWidgets('keeps explicit errorText ahead of validate result', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppTextField(
            errorText: 'Lỗi từ bên ngoài',
            validate: (value) => 'Lỗi validate',
          ),
        ),
      );

      expect(find.text('Lỗi từ bên ngoài'), findsOneWidget);
      expect(find.text('Lỗi validate'), findsNothing);
    });

    testWidgets(
      'keeps helper text visible for danger styling without errorText',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            const AppTextField(
              helperText: 'Need at least 8 characters',
              variant: AppTextFieldVariant.danger,
            ),
          ),
        );

        final helperText = tester.widget<Text>(
          find.text('Need at least 8 characters'),
        );

        expect(find.text('Need at least 8 characters'), findsOneWidget);
        expect(helperText.style?.color, ColorTokens.textDescription);
      },
    );
  });
}
