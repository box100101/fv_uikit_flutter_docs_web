import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppModal', () {
    testWidgets('keeps modal height stable when keyboard insets change', (
      WidgetTester tester,
    ) async {
      final Key modalKey = UniqueKey();

      addTearDown(tester.view.reset);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);

      await tester.pumpWidget(
        buildApp(
          Builder(
            builder: (BuildContext context) {
              return TextButton(
                onPressed: () {
                  AppModal.show<void>(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (_) => SizedBox(
                          key: modalKey,
                          child: const AppModal(
                            title: 'Keyboard modal',
                            child: SizedBox(width: 280, height: 260),
                          ),
                        ),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final Rect modalRectBeforeKeyboard = tester.getRect(find.byKey(modalKey));

      tester.view.viewInsets = const FakeViewPadding(bottom: 320);
      await tester.pump();
      await tester.pumpAndSettle();

      final Rect modalRectAfterKeyboard = tester.getRect(find.byKey(modalKey));

      expect(
        modalRectAfterKeyboard.height,
        closeTo(modalRectBeforeKeyboard.height, 0.1),
      );
    });

    testWidgets('moves modal up to keep focused OTP field above keyboard', (
      WidgetTester tester,
    ) async {
      final Key modalKey = UniqueKey();
      final Key otpKey = UniqueKey();
      const double keyboardInset = 520;

      addTearDown(tester.view.reset);
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);

      await tester.pumpWidget(
        buildApp(
          Builder(
            builder: (BuildContext context) {
              return TextButton(
                onPressed: () {
                  AppModal.show<void>(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (_) => SizedBox(
                          key: modalKey,
                          child: AppModal(
                            title: 'OTP modal',
                            child: SizedBox(
                              width: 280,
                              height: 520,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  key: otpKey,
                                  child: const AppOtpField(),
                                ),
                              ),
                            ),
                          ),
                        ),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final Finder keyboardAwareFrameFinder = find.ancestor(
        of: find.byKey(modalKey),
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is AnimatedContainer && widget.transform != null,
        ),
      );
      final AnimatedContainer frameBeforeKeyboard = tester.widget(
        keyboardAwareFrameFinder,
      );

      await tester.tap(find.byKey(const ValueKey('app-otp-field-tap-target')));
      await tester.pumpAndSettle();

      tester.view.viewInsets = const FakeViewPadding(bottom: keyboardInset);
      await tester.pump();
      await tester.pumpAndSettle();

      final AnimatedContainer frameAfterKeyboard = tester.widget(
        keyboardAwareFrameFinder,
      );

      expect(frameBeforeKeyboard.transform!.storage[13], 0);
      expect(frameAfterKeyboard.transform!.storage[13], lessThan(0));
    });
  });
}
