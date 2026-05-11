import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uikit_docs_web/src/app.dart';
import 'package:uikit_docs_web/src/docs/content.dart';

void main() {
  test('every exported public widget has a docs entry', () {
    final expected = [...publicWidgetNames]..sort();
    expect(documentedWidgetNames, orderedEquals(expected));
  });

  testWidgets('home page renders docs shell', (tester) async {
    await tester.pumpWidget(const DocsApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('FV UIKit Docs'), findsWidgets);
    expect(find.text('UIKit Catalog'), findsOneWidget);
  });

  testWidgets('language toggle switches hero content', (tester) async {
    await tester.pumpWidget(const DocsApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Widget đã document'), findsOneWidget);

    await tester.tap(find.text('EN'));
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Documented widgets'), findsOneWidget);
  });

  testWidgets('catalog navigation opens tokens page', (tester) async {
    tester.view.physicalSize = const Size(1400, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DocsApp());
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('Tokens').first, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Design Tokens'), findsWidgets);
    expect(find.text('Color'), findsOneWidget);
  });

  testWidgets('direct route renders dropdown docs page', (tester) async {
    await tester.pumpWidget(const DocsApp(initialRoute: '/widgets/app-dropdown'));
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('AppDropdown'), findsWidgets);
    expect(find.text('Choose warehouse'), findsOneWidget);
  });

  testWidgets('direct route renders bottom sheet select docs page', (
    tester,
  ) async {
    await tester.pumpWidget(
      const DocsApp(initialRoute: '/widgets/app-bottom-sheet-select'),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('AppBottomSheetSelect'), findsWidgets);
    expect(find.text('Search warehouse'), findsOneWidget);
  });

  testWidgets('button live example updates state', (tester) async {
    await tester.pumpWidget(const DocsApp(initialRoute: '/widgets/app-button'));
    await tester.pump(const Duration(milliseconds: 250));

    await tester.ensureVisible(find.text('Increase count (0)'));
    await tester.tap(find.text('Increase count (0)'), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Increase count (1)'), findsOneWidget);
  });

  testWidgets('text field validation example shows error feedback', (tester) async {
    await tester.pumpWidget(const DocsApp(initialRoute: '/widgets/app-text-field'));
    await tester.pump(const Duration(milliseconds: 250));

    await tester.enterText(find.byType(TextField).last, 'invalid');
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Invalid email format'), findsOneWidget);
  });

  testWidgets('alert example opens overlay feedback', (tester) async {
    await tester.pumpWidget(const DocsApp(initialRoute: '/widgets/app-alert'));
    await tester.pump(const Duration(milliseconds: 250));

    await tester.ensureVisible(find.text('Show success alert'));
    await tester.tap(find.text('Show success alert'), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Saved'), findsOneWidget);
  });
}
