import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppButton style overrides', () {
    testWidgets(
      'allows ButtonStyle backgroundColor to override variant color',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            AppButton(
              variant: AppButtonVariant.primary,
              text: 'Tiếp tục',
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.amber),
              ),
            ),
          ),
        );

        final ElevatedButton button = tester.widget(
          find.byType(ElevatedButton),
        );

        expect(
          button.style?.backgroundColor?.resolve(<WidgetState>{}),
          Colors.amber,
        );
      },
    );

    testWidgets('applies backgroundColor shortcut without changing API flow', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.primary,
            text: 'Xác nhận',
            onPressed: () {},
            backgroundColor: Colors.green,
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      expect(
        button.style?.backgroundColor?.resolve(<WidgetState>{}),
        Colors.green,
      );
    });

    testWidgets('applies border for outline variant', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.outline,
            text: 'Xem chi tiet',
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

    testWidgets('allows borderColor to override outline border color', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.outline,
            text: 'Xem chi tiet',
            borderColor: Colors.red,
            onPressed: () {},
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      expect(
        button.style?.side?.resolve(<WidgetState>{}),
        const BorderSide(color: Colors.red),
      );
    });

    testWidgets('renders a dashed border for dash variant', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.dash,
            text: 'Tai xuong',
            onPressed: () {},
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      final CustomPaint dashedBorder = tester.widget(
        find.byWidgetPredicate(
          (widget) =>
              widget is CustomPaint &&
              widget.foregroundPainter.runtimeType.toString() ==
                  '_DashedRoundedRectPainter',
        ),
      );

      expect(
        button.style?.side?.resolve(<WidgetState>{}),
        const BorderSide(color: ColorTokens.transparent),
      );
      expect(dashedBorder.foregroundPainter, isNotNull);
    });

    testWidgets('keeps text variant visually flat when enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.text,
            text: 'Chi tiet',
            onPressed: () {},
          ),
        ),
      );

      final TextButton button = tester.widget(find.byType(TextButton));

      expect(
        button.style?.backgroundColor?.resolve(<WidgetState>{}),
        ColorTokens.transparent,
      );
      expect(
        button.style?.overlayColor?.resolve(<WidgetState>{}),
        ColorTokens.transparent,
      );
      expect(button.style?.elevation?.resolve(<WidgetState>{}), 0);
      expect(
        button.style?.shadowColor?.resolve(<WidgetState>{}),
        ColorTokens.transparent,
      );
      expect(
        button.style?.surfaceTintColor?.resolve(<WidgetState>{}),
        ColorTokens.transparent,
      );
    });

    testWidgets('keeps link variant visually flat when enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.link,
            text: 'Xem them',
            onPressed: () {},
          ),
        ),
      );

      final TextButton button = tester.widget(find.byType(TextButton));

      expect(
        button.style?.backgroundColor?.resolve(<WidgetState>{}),
        ColorTokens.transparent,
      );
      expect(
        button.style?.overlayColor?.resolve(<WidgetState>{}),
        ColorTokens.transparent,
      );
      expect(button.style?.elevation?.resolve(<WidgetState>{}), 0);
      expect(
        button.style?.shadowColor?.resolve(<WidgetState>{}),
        ColorTokens.transparent,
      );
      expect(
        button.style?.surfaceTintColor?.resolve(<WidgetState>{}),
        ColorTokens.transparent,
      );
    });

    testWidgets('disables tap when isDisabled is true', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.primary,
            text: 'Khong bam duoc',
            isDisabled: true,
            onPressed: () {
              tapCount += 1;
            },
          ),
        ),
      );

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      expect(button.onPressed, isNull);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(tapCount, 0);
    });

    testWidgets('applies opacity when button is disabled', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.primary,
            text: 'Mo',
            isDisabled: true,
            onPressed: () {},
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Opacity && widget.opacity == 0.5,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'shows loading indicator, keeps size, and disables tap while loading',
      (tester) async {
        var tapCount = 0;

        await tester.pumpWidget(
          buildApp(
            AppButton(
              variant: AppButtonVariant.primary,
              text: 'Dang gui',
              onPressed: () {
                tapCount += 1;
              },
            ),
          ),
        );

        final initialSize = tester.getSize(find.byType(ElevatedButton));

        await tester.pumpWidget(
          buildApp(
            AppButton(
              variant: AppButtonVariant.primary,
              text: 'Dang gui',
              isLoading: true,
              onPressed: () {
                tapCount += 1;
              },
            ),
          ),
        );

        final ElevatedButton button = tester.widget(
          find.byType(ElevatedButton),
        );

        expect(button.onPressed, isNull);
        expect(find.byType(AppLoadingSpinner), findsOneWidget);
        expect(find.text('Dang gui'), findsOneWidget);
        expect(tester.getSize(find.byType(ElevatedButton)), initialSize);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(tapCount, 0);
      },
    );

    testWidgets('merges text style from ButtonStyle and textStyle', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.primary,
            text: 'Tạo mới',
            onPressed: () {},
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(
                const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
            ),
            textStyle: const TextStyle(
              letterSpacing: 1.2,
              color: Colors.orange,
            ),
          ),
        ),
      );

      final Text label = tester.widget(find.text('Tạo mới'));

      expect(label.style?.fontSize, 18);
      expect(label.style?.fontWeight, FontWeight.w700);
      expect(label.style?.letterSpacing, 1.2);
      expect(label.style?.color, Colors.orange);
    });

    testWidgets(
      'allows textFontSize and textColor shortcuts to override resolved text style',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            AppButton(
              variant: AppButtonVariant.primary,
              text: 'Tạo mới',
              onPressed: () {},
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ),
              textStyle: const TextStyle(
                letterSpacing: 1.2,
                color: Colors.orange,
              ),
              textFontSize: 20,
              textColor: Colors.blue,
            ),
          ),
        );

        final Text label = tester.widget(find.text('Tạo mới'));

        expect(label.style?.fontSize, 20);
        expect(label.style?.color, Colors.blue);
        expect(label.style?.fontWeight, FontWeight.w700);
        expect(label.style?.letterSpacing, 1.2);
      },
    );

    testWidgets(
      'buttons shrink horizontally to content and keep medium size defaults',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            AppButton(
              variant: AppButtonVariant.primary,
              text: 'A',
              onPressed: () {},
            ),
          ),
        );

        final buttonFinder = find.byType(ElevatedButton);
        final ElevatedButton button = tester.widget(buttonFinder);

        expect(
          button.style?.padding?.resolve(<WidgetState>{}),
          const EdgeInsets.symmetric(horizontal: SpacingTokens.paddingL),
        );
        expect(
          button.style?.minimumSize?.resolve(<WidgetState>{}),
          const Size(0, 48),
        );
        expect(tester.getSize(buttonFinder).height, 48);
        expect(tester.getSize(buttonFinder).width, lessThan(64));
      },
    );

    testWidgets('maps xSmall size to compact content metrics', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.primary,
            size: AppButtonSize.xSmall,
            text: 'XS',
            iconLeft: const Icon(Icons.add),
            onPressed: () {},
          ),
        ),
      );

      final buttonFinder = find.byType(ElevatedButton);
      final ElevatedButton button = tester.widget(buttonFinder);
      final Text label = tester.widget(find.text('XS'));
      final IconTheme iconTheme = tester.widget(
        find
            .ancestor(
              of: find.byIcon(Icons.add),
              matching: find.byType(IconTheme),
            )
            .first,
      );

      expect(
        button.style?.padding?.resolve(<WidgetState>{}),
        const EdgeInsets.symmetric(horizontal: SpacingTokens.paddingM),
      );
      expect(
        button.style?.minimumSize?.resolve(<WidgetState>{}),
        const Size(0, 32),
      );
      expect(tester.getSize(buttonFinder).height, 32);
      expect(label.style?.fontSize, TextStyleTokens.bodyXSMedium.fontSize);
      expect(
        find.descendant(
          of: buttonFinder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox &&
                widget.width == SpacingTokens.gapXS &&
                widget.height == null,
          ),
        ),
        findsOneWidget,
      );
      expect(iconTheme.data.size, IconSizeTokens.iconSizeS);
    });

    testWidgets('maps xLarge size to expanded content metrics', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.primary,
            size: AppButtonSize.xLarge,
            text: 'XL',
            iconRight: const Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        ),
      );

      final buttonFinder = find.byType(ElevatedButton);
      final ElevatedButton button = tester.widget(buttonFinder);
      final Text label = tester.widget(find.text('XL'));
      final IconTheme iconTheme = tester.widget(
        find
            .ancestor(
              of: find.byIcon(Icons.arrow_forward),
              matching: find.byType(IconTheme),
            )
            .first,
      );

      expect(
        button.style?.padding?.resolve(<WidgetState>{}),
        const EdgeInsets.symmetric(horizontal: SpacingTokens.paddingXL),
      );
      expect(
        button.style?.minimumSize?.resolve(<WidgetState>{}),
        const Size(0, 64),
      );
      expect(tester.getSize(buttonFinder).height, 64);
      expect(label.style?.fontSize, TextStyleTokens.bodyXLMedium.fontSize);
      expect(
        find.descendant(
          of: buttonFinder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox &&
                widget.width == SpacingTokens.gapM &&
                widget.height == null,
          ),
        ),
        findsOneWidget,
      );
      expect(iconTheme.data.size, IconSizeTokens.iconSizeL);
    });

    testWidgets(
      'does not expand to full width under tight horizontal constraints',
      (tester) async {
        await tester.pumpWidget(
          buildApp(
            SizedBox(
              width: 300,
              child: AppButton(
                variant: AppButtonVariant.primary,
                text: 'A',
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(
          tester.getSize(find.byType(ElevatedButton)).width,
          lessThan(300),
        );
      },
    );

    testWidgets('does not expand to the full ListView cross-axis width', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 300,
            child: ListView(
              children: [
                AppButton(
                  variant: AppButtonVariant.primary,
                  text: 'A',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(ElevatedButton)).width, lessThan(300));
    });

    testWidgets('expands to full width when isFullWidth is enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          SizedBox(
            width: 300,
            child: AppButton(
              variant: AppButtonVariant.primary,
              text: 'A',
              isFullWidth: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(ElevatedButton)).width, 300);
    });

    testWidgets('preserves caller minimumSize override', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppButton(
            variant: AppButtonVariant.primary,
            text: 'A',
            onPressed: () {},
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(const Size(120, 40)),
            ),
          ),
        ),
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byType(ElevatedButton))
            .style
            ?.minimumSize
            ?.resolve(<WidgetState>{}),
        const Size(120, 40),
      );
    });
  });
}
