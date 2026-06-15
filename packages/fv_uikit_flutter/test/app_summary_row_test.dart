import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  testWidgets('AppSummaryRow renders label and value', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSummaryRow(
            label: 'Total amount',
            value: '100,000 đ',
            isBold: true,
          ),
        ),
      ),
    );

    expect(find.text('Total amount'), findsOneWidget);
    expect(find.text('100,000 đ'), findsOneWidget);
    expect(find.byType(AppDivider), findsOneWidget);
  });

  testWidgets('AppSummaryRow renders custom valueWidget and ignores value', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSummaryRow(
            label: 'Total amount',
            value: '100,000 đ',
            valueWidget: Text('Custom Widget'),
          ),
        ),
      ),
    );

    expect(find.text('Total amount'), findsOneWidget);
    expect(find.text('Custom Widget'), findsOneWidget);
    expect(find.text('100,000 đ'), findsNothing);
  });

  testWidgets('AppSummaryRow does not render AppDivider when showBottomDivider is false', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSummaryRow(
            label: 'Total amount',
            value: '100,000 đ',
            showBottomDivider: false,
          ),
        ),
      ),
    );

    expect(find.byType(AppDivider), findsNothing);
  });

  testWidgets('AppSummaryRow bold state verifies text styles and colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSummaryRow(
            label: 'Bold Label',
            value: 'Bold Value',
            isBold: true,
          ),
        ),
      ),
    );

    final labelAppText = tester.widget<AppText>(find.widgetWithText(AppText, 'Bold Label'));
    final valueAppText = tester.widget<AppText>(find.widgetWithText(AppText, 'Bold Value'));

    expect(labelAppText.size, AppTextSize.bodyMBold);
    expect(labelAppText.color, ColorTokens.textDefault);

    expect(valueAppText.size, AppTextSize.bodyMBold);
    expect(valueAppText.color, ColorTokens.textDefault);
  });

  testWidgets('AppSummaryRow regular state verifies text styles and colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSummaryRow(
            label: 'Regular Label',
            value: 'Regular Value',
            isBold: false,
          ),
        ),
      ),
    );

    final labelAppText = tester.widget<AppText>(find.widgetWithText(AppText, 'Regular Label'));
    final valueAppText = tester.widget<AppText>(find.widgetWithText(AppText, 'Regular Value'));

    expect(labelAppText.size, AppTextSize.bodyMRegular);
    expect(labelAppText.color, ColorTokens.textSecondary);

    expect(valueAppText.size, AppTextSize.bodyMRegular);
    expect(valueAppText.color, ColorTokens.textDefault);
  });
}
