import 'package:flutter/material.dart';

abstract class RadiusTokens {
  // POS semantic radius
  static const BorderRadiusGeometry none = BorderRadius.zero;

  static const double radiusXS = 2;
  static const double radiusS = 4;
  static const double radiusM = 6;
  static const double radiusL = 8;
  static const double radiusXL = 10;

  static const BorderRadiusGeometry radiusXsBorderRadius = BorderRadius.all(
    Radius.circular(radiusXS),
  );
  static const BorderRadiusGeometry radiusSmBorderRadius = BorderRadius.all(
    Radius.circular(radiusS),
  );
  static const BorderRadiusGeometry radiusMdBorderRadius = BorderRadius.all(
    Radius.circular(radiusM),
  );
  static const BorderRadiusGeometry radiusLgBorderRadius = BorderRadius.all(
    Radius.circular(radiusL),
  );
  static const BorderRadiusGeometry radiusXlBorderRadius = BorderRadius.all(
    Radius.circular(radiusXL),
  );

  static const BorderRadiusGeometry verticalRadiusXsBorderRadius =
      BorderRadius.vertical(
        top: Radius.circular(radiusXS),
        bottom: Radius.circular(radiusXS),
      );
  static const BorderRadiusGeometry verticalRadiusSmBorderRadius =
      BorderRadius.vertical(
        top: Radius.circular(radiusS),
        bottom: Radius.circular(radiusS),
      );
  static const BorderRadiusGeometry verticalRadiusMdBorderRadius =
      BorderRadius.vertical(
        top: Radius.circular(radiusM),
        bottom: Radius.circular(radiusM),
      );
  static const BorderRadiusGeometry verticalRadiusLgBorderRadius =
      BorderRadius.vertical(
        top: Radius.circular(radiusL),
        bottom: Radius.circular(radiusL),
      );
  static const BorderRadiusGeometry verticalRadiusXlBorderRadius =
      BorderRadius.vertical(
        top: Radius.circular(radiusXL),
        bottom: Radius.circular(radiusXL),
      );

  static const BorderRadiusGeometry horizontalRadiusXsBorderRadius =
      BorderRadius.horizontal(
        left: Radius.circular(radiusXS),
        right: Radius.circular(radiusXS),
      );
  static const BorderRadiusGeometry horizontalRadiusSmBorderRadius =
      BorderRadius.horizontal(
        left: Radius.circular(radiusS),
        right: Radius.circular(radiusS),
      );
  static const BorderRadiusGeometry horizontalRadiusMdBorderRadius =
      BorderRadius.horizontal(
        left: Radius.circular(radiusM),
        right: Radius.circular(radiusM),
      );
  static const BorderRadiusGeometry horizontalRadiusLgBorderRadius =
      BorderRadius.horizontal(
        left: Radius.circular(radiusL),
        right: Radius.circular(radiusL),
      );
  static const BorderRadiusGeometry horizontalRadiusXlBorderRadius =
      BorderRadius.horizontal(
        left: Radius.circular(radiusXL),
        right: Radius.circular(radiusXL),
      );
}
