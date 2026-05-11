import 'package:flutter/material.dart';

abstract class BoxShadowTokens {
  static const List<BoxShadow> boxShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 28,
      spreadRadius: 8,
      offset: Offset(0, 9),
    ),
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 6,
      spreadRadius: -4,
      offset: Offset(0, 3),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> boxShadowSecondary = <BoxShadow>[
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 28,
      spreadRadius: 8,
      offset: Offset(0, 9),
    ),
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 6,
      spreadRadius: -4,
      offset: Offset(0, 3),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> boxShadowTertiary = <BoxShadow>[
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 4,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 6,
      spreadRadius: -1,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 2,
      spreadRadius: 0,
      offset: Offset(0, 1),
    ),
  ];

  // Compatibility aliases
  static const BoxShadow sm = BoxShadow(
    color: Color(0x05000000),
    blurRadius: 4,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );

  static const BoxShadow md = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 16,
    spreadRadius: 0,
    offset: Offset(0, 6),
  );

  static const BoxShadow lg = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 28,
    spreadRadius: 8,
    offset: Offset(0, 9),
  );
}
