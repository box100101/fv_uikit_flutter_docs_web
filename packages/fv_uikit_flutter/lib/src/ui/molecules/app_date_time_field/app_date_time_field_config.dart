part of 'app_date_time_field.dart';

typedef AppDatePicker =
    Future<DateTime?> Function(
      BuildContext context,
      DateTime initialDate,
      DateTime firstDate,
      DateTime lastDate,
    );

typedef AppTimePicker =
    Future<TimeOfDay?> Function(BuildContext context, TimeOfDay initialTime);

typedef AppDateFormatter = String Function(DateTime value);
typedef AppTimeFormatter = String Function(TimeOfDay value);
typedef AppDateTimeFormatter = String Function(DateTime value);

class AppDateTimePickerStyle {
  final String? dateTitleText;
  final String? timeTitleText;
  final String? dateTimeTitleText;
  final String? cancelText;
  final String? confirmText;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final Color? titleColor;
  final Color? headerBackgroundColor;
  final Color? headerForegroundColor;
  final TextStyle? headerTitleTextStyle;
  final TextStyle? headerHeadlineTextStyle;
  final Color? entryModeIconColor;
  final Icon? dateSwitchToInputEntryModeIcon;
  final Icon? dateSwitchToCalendarEntryModeIcon;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final Color? actionTextColor;
  final BorderRadius? dialogBorderRadius;

  const AppDateTimePickerStyle({
    this.dateTitleText,
    this.timeTitleText,
    this.dateTimeTitleText,
    this.cancelText,
    this.confirmText,
    this.selectedColor,
    this.selectedTextColor,
    this.titleColor,
    this.headerBackgroundColor,
    this.headerForegroundColor,
    this.headerTitleTextStyle,
    this.headerHeadlineTextStyle,
    this.entryModeIconColor,
    this.dateSwitchToInputEntryModeIcon,
    this.dateSwitchToCalendarEntryModeIcon,
    this.backgroundColor,
    this.surfaceTintColor,
    this.actionTextColor,
    this.dialogBorderRadius,
  });
}
