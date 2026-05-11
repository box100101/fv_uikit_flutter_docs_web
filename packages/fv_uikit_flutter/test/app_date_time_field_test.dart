import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  group('AppDateTimeField display', () {
    testWidgets('uses default hints and suffix icons by mode', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const Column(
            children: [
              AppDateTimeField(mode: AppDateTimeFieldMode.date),
              AppDateTimeField(mode: AppDateTimeFieldMode.time),
              AppDateTimeField(mode: AppDateTimeFieldMode.dateTime),
            ],
          ),
        ),
      );

      expect(find.text('Select date DD/MM/YYYY'), findsOneWidget);
      expect(find.text('Select time HH:MM'), findsOneWidget);
      expect(find.text('Select date DD/MM/YYYY HH:MM'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_outlined), findsNWidgets(2));
      expect(find.byIcon(Icons.access_time_outlined), findsOneWidget);
    });

    testWidgets('formats date, time, and date time values', (tester) async {
      await tester.pumpWidget(
        buildApp(
          Column(
            children: [
              AppDateTimeField(
                mode: AppDateTimeFieldMode.date,
                value: DateTime(2026, 5, 7),
              ),
              const AppDateTimeField(
                mode: AppDateTimeFieldMode.time,
                timeValue: TimeOfDay(hour: 9, minute: 5),
              ),
              AppDateTimeField(
                mode: AppDateTimeFieldMode.dateTime,
                value: DateTime(2026, 5, 7, 14, 30),
              ),
            ],
          ),
        ),
      );

      expect(find.text('07/05/2026'), findsOneWidget);
      expect(find.text('09:05'), findsOneWidget);
      expect(find.text('07/05/2026 14:30'), findsOneWidget);
    });

    testWidgets('passes through field size and rounded shape', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppDateTimeField(
            size: AppTextFieldSize.xLarge,
            isRounded: true,
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration! as BoxDecoration;

      expect(container.constraints?.minHeight, 64);
      expect(decoration.borderRadius, BorderRadius.circular(32));
    });

    testWidgets('uses primary picker colors by default', (tester) async {
      await tester.pumpWidget(
        buildApp(AppDateTimeField(value: DateTime(2026, 5, 7))),
      );

      await tester.tap(find.byType(AppDateTimeField));
      await tester.pumpAndSettle();

      final theme = Theme.of(tester.element(find.byType(DatePickerDialog)));

      expect(theme.colorScheme.primary, ColorTokens.primaryDefault);
      expect(theme.colorScheme.onPrimary, ColorTokens.white);
      expect(
        theme.datePickerTheme.headerBackgroundColor,
        ColorTokens.primaryDefault,
      );
      expect(theme.datePickerTheme.headerForegroundColor, ColorTokens.white);
    });

    testWidgets('passes labels and colors to material date picker', (
      tester,
    ) async {
      const selectedColor = Color(0xFF1565C0);
      const selectedTextColor = Color(0xFFFFFFFF);
      const titleColor = Color(0xFF263238);
      const headerBackgroundColor = Color(0xFF0D47A1);
      const headerForegroundColor = Color(0xFFFFF8E1);
      const headerTitleStyle = TextStyle(fontSize: 18);
      const headerHeadlineStyle = TextStyle(fontSize: 34);
      const dialogBorderRadius = BorderRadius.all(Radius.circular(28));

      await tester.pumpWidget(
        buildApp(
          AppDateTimeField(
            value: DateTime(2026, 5, 7),
            pickerStyle: const AppDateTimePickerStyle(
              dateTitleText: 'Chọn ngày',
              cancelText: 'Huỷ',
              confirmText: 'Xong',
              selectedColor: selectedColor,
              selectedTextColor: selectedTextColor,
              titleColor: titleColor,
              headerBackgroundColor: headerBackgroundColor,
              headerForegroundColor: headerForegroundColor,
              headerTitleTextStyle: headerTitleStyle,
              headerHeadlineTextStyle: headerHeadlineStyle,
              entryModeIconColor: ColorTokens.warningDefault,
              dateSwitchToInputEntryModeIcon: Icon(Icons.edit_calendar),
              dialogBorderRadius: dialogBorderRadius,
              actionTextColor: ColorTokens.dangerDefault,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppDateTimeField));
      await tester.pumpAndSettle();

      expect(find.text('Chọn ngày'), findsOneWidget);
      expect(find.text('Huỷ'), findsOneWidget);
      expect(find.text('Xong'), findsOneWidget);

      final theme = Theme.of(tester.element(find.byType(DatePickerDialog)));

      expect(theme.colorScheme.primary, selectedColor);
      expect(theme.colorScheme.onPrimary, selectedTextColor);
      expect(theme.colorScheme.onSurface, titleColor);
      expect(
        theme.datePickerTheme.headerBackgroundColor,
        headerBackgroundColor,
      );
      expect(
        theme.datePickerTheme.headerForegroundColor,
        headerForegroundColor,
      );
      expect(theme.datePickerTheme.headerHelpStyle, headerTitleStyle);
      expect(theme.datePickerTheme.headerHeadlineStyle, headerHeadlineStyle);
      expect(
        theme.datePickerTheme.shape,
        const RoundedRectangleBorder(borderRadius: dialogBorderRadius),
      );
      expect(find.byIcon(Icons.edit_calendar), findsOneWidget);
    });

    testWidgets('passes labels and colors to material time picker', (
      tester,
    ) async {
      const selectedColor = Color(0xFF2E7D32);
      const titleColor = Color(0xFF1B1B1B);

      await tester.pumpWidget(
        buildApp(
          const AppDateTimeField(
            mode: AppDateTimeFieldMode.time,
            timeValue: TimeOfDay(hour: 9, minute: 5),
            pickerStyle: AppDateTimePickerStyle(
              timeTitleText: 'Chọn giờ',
              cancelText: 'Đóng',
              confirmText: 'Áp dụng',
              selectedColor: selectedColor,
              titleColor: titleColor,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppDateTimeField));
      await tester.pumpAndSettle();

      expect(find.text('Chọn giờ'), findsOneWidget);
      expect(find.text('Đóng'), findsOneWidget);
      expect(find.text('Áp dụng'), findsOneWidget);

      final theme = Theme.of(tester.element(find.byType(TimePickerDialog)));

      expect(theme.colorScheme.primary, selectedColor);
      expect(theme.colorScheme.onSurface, titleColor);
      expect(theme.timePickerTheme.dialHandColor, selectedColor);
      expect(theme.timePickerTheme.hourMinuteTextColor, titleColor);
    });

    testWidgets('opens date picker inside app bottom sheet', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppDateTimeField(
            pickerPresentation: AppDateTimePickerPresentation.bottomSheet,
          ),
        ),
      );

      await tester.tap(find.byType(AppDateTimeField));
      await tester.pumpAndSettle();

      expect(find.byType(AppBottomSheet), findsOneWidget);
      expect(find.byType(CalendarDatePicker), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });
  });

  group('AppDateTimeField behavior', () {
    testWidgets('picks date and calls onChanged', (tester) async {
      DateTime? changedValue;

      await tester.pumpWidget(
        buildApp(
          AppDateTimeField(
            mode: AppDateTimeFieldMode.date,
            onChanged: (value) => changedValue = value,
            datePicker:
                (context, initialDate, firstDate, lastDate) =>
                    Future.value(DateTime(2026, 5, 7, 18)),
          ),
        ),
      );

      await tester.tap(find.byType(AppDateTimeField));
      await tester.pumpAndSettle();

      expect(find.text('07/05/2026'), findsOneWidget);
      expect(changedValue, DateTime(2026, 5, 7));
    });

    testWidgets('picks time and calls onTimeChanged', (tester) async {
      TimeOfDay? changedValue;

      await tester.pumpWidget(
        buildApp(
          AppDateTimeField(
            mode: AppDateTimeFieldMode.time,
            onTimeChanged: (value) => changedValue = value,
            timePicker:
                (context, initialTime) =>
                    Future.value(const TimeOfDay(hour: 16, minute: 45)),
          ),
        ),
      );

      await tester.tap(find.byType(AppDateTimeField));
      await tester.pumpAndSettle();

      expect(find.text('16:45'), findsOneWidget);
      expect(changedValue, const TimeOfDay(hour: 16, minute: 45));
    });

    testWidgets('picks date time and calls both callbacks', (tester) async {
      DateTime? changedDateTime;
      TimeOfDay? changedTime;

      await tester.pumpWidget(
        buildApp(
          AppDateTimeField(
            mode: AppDateTimeFieldMode.dateTime,
            onChanged: (value) => changedDateTime = value,
            onTimeChanged: (value) => changedTime = value,
            datePicker:
                (context, initialDate, firstDate, lastDate) =>
                    Future.value(DateTime(2026, 5, 7)),
            timePicker:
                (context, initialTime) =>
                    Future.value(const TimeOfDay(hour: 11, minute: 31)),
          ),
        ),
      );

      await tester.tap(find.byType(AppDateTimeField));
      await tester.pumpAndSettle();

      expect(find.text('07/05/2026 11:31'), findsOneWidget);
      expect(changedDateTime, DateTime(2026, 5, 7, 11, 31));
      expect(changedTime, const TimeOfDay(hour: 11, minute: 31));
    });

    testWidgets('does not open picker while disabled', (tester) async {
      var pickerCallCount = 0;

      await tester.pumpWidget(
        buildApp(
          AppDateTimeField(
            isDisabled: true,
            datePicker: (context, initialDate, firstDate, lastDate) {
              pickerCallCount++;
              return Future.value(DateTime(2026, 5, 7));
            },
          ),
        ),
      );

      await tester.tap(find.byType(AppDateTimeField));
      await tester.pumpAndSettle();

      expect(pickerCallCount, 0);
      expect(find.text('Select date DD/MM/YYYY'), findsOneWidget);
    });

    testWidgets(
      'uses vertical scroll time picker inside bottom sheet and calls onTimeChanged',
      (tester) async {
        TimeOfDay? changedValue;

        await tester.pumpWidget(
          buildApp(
            AppDateTimeField(
              mode: AppDateTimeFieldMode.time,
              pickerPresentation: AppDateTimePickerPresentation.bottomSheet,
              onTimeChanged: (value) => changedValue = value,
            ),
          ),
        );

        await tester.tap(find.byType(AppDateTimeField));
        await tester.pumpAndSettle();

        expect(find.byType(CupertinoDatePicker), findsOneWidget);

        final picker = tester.widget<CupertinoDatePicker>(
          find.byType(CupertinoDatePicker),
        );
        picker.onDateTimeChanged(DateTime(2026, 5, 7, 18, 25));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(find.text('18:25'), findsOneWidget);
        expect(changedValue, const TimeOfDay(hour: 18, minute: 25));
      },
    );

    testWidgets('picks date time from a single bottom sheet flow', (
      tester,
    ) async {
      DateTime? changedDateTime;
      TimeOfDay? changedTime;

      await tester.pumpWidget(
        buildApp(
          AppDateTimeField(
            mode: AppDateTimeFieldMode.dateTime,
            pickerPresentation: AppDateTimePickerPresentation.bottomSheet,
            onChanged: (value) => changedDateTime = value,
            onTimeChanged: (value) => changedTime = value,
          ),
        ),
      );

      await tester.tap(find.byType(AppDateTimeField));
      await tester.pumpAndSettle();

      final datePicker = tester.widget<CalendarDatePicker>(
        find.byType(CalendarDatePicker),
      );
      datePicker.onDateChanged(DateTime(2026, 5, 7));

      final timePicker = tester.widget<CupertinoDatePicker>(
        find.byType(CupertinoDatePicker),
      );
      timePicker.onDateTimeChanged(DateTime(2026, 5, 7, 11, 31));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('07/05/2026 11:31'), findsOneWidget);
      expect(changedDateTime, DateTime(2026, 5, 7, 11, 31));
      expect(changedTime, const TimeOfDay(hour: 11, minute: 31));
    });
  });
}
