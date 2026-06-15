import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  group('ColorTokens', () {
    test('maps POS semantic colors and compatibility aliases', () {
      expect(ColorTokens.text, const Color(0xE0000000));
      expect(ColorTokens.primaryBg, const Color(0xFFEFF6FF));
      expect(ColorTokens.warningBorderHover, const Color(0xFFFDBA74));
      expect(ColorTokens.primary, const Color(0xFF155EEF));
      expect(ColorTokens.primaryDefault, ColorPaletteTokens.posLightBlue600);
      expect(ColorTokens.error, ColorTokens.danger);
      expect(ColorTokens.dangerDefault, ColorPaletteTokens.posRed600);
      expect(ColorTokens.gray900, ColorPaletteTokens.ecoInk1000);
    });
  });

  group('Spacing and size tokens', () {
    test('maps mobile and tablet dimensions', () {
      expect(SpacingTokens.insetDefault, 12.0);
      expect(SpacingTabletTokens.insetDefault, 16.0);
      expect(ComponentSizeTokens.componentM, 32.0);
      expect(ComponentSizeTabletTokens.componentM, 40.0);
      expect(BreakpointsTokens.device, 390.0);
      expect(BreakpointsTokens.deviceTablet, 1280.0);
    });

    test('keeps spacing compatibility aliases', () {
      expect(SpacingTokens.spaceS, 8.0);
      expect(SpacingTokens.paddingM, 12.0);
      expect(SpacingTokens.marginXL, 24.0);
      expect(SpacingTokens.gap4XL, 48.0);
    });
  });

  group('RadiusTokens', () {
    test('maps semantic radius values', () {
      expect(RadiusTokens.radiusXS, 2.0);
      expect(RadiusTokens.radiusS, 4.0);
      expect(RadiusTokens.radiusM, 6.0);
      expect(RadiusTokens.radiusL, 8.0);
      expect(RadiusTokens.radiusXL, 10.0);
    });
  });

  group('TypographyTokens', () {
    test('maps primitives from POS font scale', () {
      expect(TypographyTokens.fontFamily, 'Inter');
      expect(TypographyTokens.fontWeightMedium, FontWeight.w500);
      expect(TypographyTokens.paragraphSFontSize, 14.0);
      expect(TypographyTokens.heading1LineHeight, 76.0);
      expect(TypographyTokens.paragraphLFontSize, 18.0);
    });

    test('builds text styles with pixel line height ratio', () {
      expect(TextStyleTokens.bodySRegular.fontFamily, TypographyTokens.fontFamily);
      expect(TextStyleTokens.bodySRegular.fontSize, 14.0);
      expect(TextStyleTokens.bodySRegular.fontWeight, FontWeight.w400);
      expect(
        TextStyleTokens.bodySRegular.letterSpacing,
        TypographyTokens.paragraphSLetterSpacing,
      );
      expect(TextStyleTokens.bodySRegular.height, closeTo(20 / 14, 0.000001));

      expect(
        TextStyleTokens.heading1Bold.letterSpacing,
        TypographyTokens.heading1LetterSpacing,
      );
      expect(TextStyleTokens.bodyMMedium.fontWeight, FontWeight.w500);
      expect(TextStyleTokens.heading3Bold.height, closeTo(44 / 36, 0.000001));
    });
  });

  group('BoxShadowTokens', () {
    test('maps generic shadow stacks and compatibility aliases', () {
      expect(BoxShadowTokens.boxShadow, hasLength(3));
      expect(BoxShadowTokens.boxShadowSecondary, hasLength(3));
      expect(BoxShadowTokens.boxShadowTertiary, hasLength(3));
      expect(BoxShadowTokens.sm.blurRadius, 4);
      expect(BoxShadowTokens.md.blurRadius, 16);
      expect(BoxShadowTokens.lg.spreadRadius, 8);
    });
  });
}
