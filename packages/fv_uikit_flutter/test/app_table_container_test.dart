import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  testWidgets('AppTableContainer renders child widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppTableContainer(
            child: Text('Test Table'),
          ),
        ),
      ),
    );

    expect(find.text('Test Table'), findsOneWidget);
  });
}
