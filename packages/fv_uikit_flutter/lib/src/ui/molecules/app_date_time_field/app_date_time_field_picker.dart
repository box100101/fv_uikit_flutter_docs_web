part of 'app_date_time_field.dart';

extension _AppDateTimeFieldPicker on _AppDateTimeFieldState {
  Future<DateTime?> _showDatePicker() {
    final firstDate = widget.firstDate ?? DateTime(1900);
    final lastDate = widget.lastDate ?? DateTime(2100);
    final initialDate = _clampDate(
      _selectedDate ?? widget.initialPickerDate ?? DateTime.now(),
      firstDate,
      lastDate,
    );

    final picker =
        widget.datePicker ??
        (_usesBottomSheetPicker ? _bottomSheetDatePicker : _materialDatePicker);

    return picker(context, initialDate, firstDate, lastDate);
  }

  Future<TimeOfDay?> _showTimePicker() {
    final initialTime =
        _selectedTime ??
        widget.initialPickerTime ??
        (_selectedDate == null
            ? TimeOfDay.now()
            : TimeOfDay.fromDateTime(_selectedDate!));
    final picker =
        widget.timePicker ??
        (_usesBottomSheetPicker ? _bottomSheetTimePicker : _materialTimePicker);

    return picker(context, initialTime);
  }

  Future<DateTime?> _showBottomSheetDateTimePicker() {
    final firstDate = widget.firstDate ?? DateTime(1900);
    final lastDate = widget.lastDate ?? DateTime(2100);
    final initialDate = _clampDate(
      _selectedDate ?? widget.initialPickerDate ?? DateTime.now(),
      firstDate,
      lastDate,
    );
    final initialTime =
        _selectedTime ??
        widget.initialPickerTime ??
        TimeOfDay.fromDateTime(initialDate);
    final pickerStyle = _effectivePickerStyle;
    var selectedDate = _dateOnly(initialDate);
    var selectedTime = initialTime;

    return AppBottomSheet.show<DateTime>(
      context: context,
      builder:
          (bottomSheetContext) => AppBottomSheet(
            title: _dateTimeBottomSheetTitle,
            size: AppBottomSheetSize.large,
            titleCancelAction: pickerStyle.cancelText ?? 'Cancel',
            onCancelAction: () => AppBottomSheet.close(bottomSheetContext),
            titlePrimaryAction: pickerStyle.confirmText ?? 'Confirm',
            onPrimaryAction:
                () => AppBottomSheet.close(
                  bottomSheetContext,
                  _combineDateAndTime(selectedDate, selectedTime),
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBottomSheetSectionLabel(_dateBottomSheetSectionTitle),
                const SizedBox(height: SpacingTokens.spaceS),
                _buildStyledPicker(
                  bottomSheetContext,
                  CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    onDateChanged: (value) {
                      selectedDate = _dateOnly(value);
                    },
                  ),
                ),
                const SizedBox(height: SpacingTokens.spaceL),
                _buildBottomSheetSectionLabel(_timeBottomSheetSectionTitle),
                const SizedBox(height: SpacingTokens.spaceS),
                _BottomSheetTimePicker(
                  initialTime: initialTime,
                  textColor: pickerStyle.titleColor ?? ColorTokens.textDefault,
                  backgroundColor:
                      pickerStyle.backgroundColor ?? ColorTokens.bgElevated,
                  onChanged: (value) {
                    selectedTime = value;
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<DateTime?> _materialDatePicker(
    BuildContext context,
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    final pickerStyle = _effectivePickerStyle;

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: widget.initialDatePickerEntryMode,
      selectableDayPredicate: widget.selectableDayPredicate,
      helpText: pickerStyle.dateTitleText,
      cancelText: pickerStyle.cancelText,
      confirmText: pickerStyle.confirmText,
      switchToInputEntryModeIcon: pickerStyle.dateSwitchToInputEntryModeIcon,
      switchToCalendarEntryModeIcon:
          pickerStyle.dateSwitchToCalendarEntryModeIcon,
      builder: _buildStyledPicker,
    );
  }

  Future<TimeOfDay?> _materialTimePicker(
    BuildContext context,
    TimeOfDay initialTime,
  ) {
    final pickerStyle = _effectivePickerStyle;

    return showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: widget.initialTimePickerEntryMode,
      helpText: pickerStyle.timeTitleText,
      cancelText: pickerStyle.cancelText,
      confirmText: pickerStyle.confirmText,
      builder: _buildStyledPicker,
    );
  }

  Future<DateTime?> _bottomSheetDatePicker(
    BuildContext context,
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    final pickerStyle = _effectivePickerStyle;
    var selectedDate = _dateOnly(initialDate);

    return AppBottomSheet.show<DateTime>(
      context: context,
      builder:
          (bottomSheetContext) => AppBottomSheet(
            title: _dateBottomSheetTitle,
            size: AppBottomSheetSize.large,
            titleCancelAction: pickerStyle.cancelText ?? 'Cancel',
            onCancelAction: () => AppBottomSheet.close(bottomSheetContext),
            titlePrimaryAction: pickerStyle.confirmText ?? 'Confirm',
            onPrimaryAction:
                () => AppBottomSheet.close(bottomSheetContext, selectedDate),
            child: _buildStyledPicker(
              bottomSheetContext,
              CalendarDatePicker(
                initialDate: initialDate,
                firstDate: firstDate,
                lastDate: lastDate,
                selectableDayPredicate: widget.selectableDayPredicate,
                onDateChanged: (value) {
                  selectedDate = _dateOnly(value);
                },
              ),
            ),
          ),
    );
  }

  Future<TimeOfDay?> _bottomSheetTimePicker(
    BuildContext context,
    TimeOfDay initialTime,
  ) {
    final pickerStyle = _effectivePickerStyle;
    var selectedTime = initialTime;

    return AppBottomSheet.show<TimeOfDay>(
      context: context,
      builder:
          (bottomSheetContext) => AppBottomSheet(
            title: _timeBottomSheetTitle,
            size: AppBottomSheetSize.medium,
            titleCancelAction: pickerStyle.cancelText ?? 'Cancel',
            onCancelAction: () => AppBottomSheet.close(bottomSheetContext),
            titlePrimaryAction: pickerStyle.confirmText ?? 'Confirm',
            onPrimaryAction:
                () => AppBottomSheet.close(bottomSheetContext, selectedTime),
            child: _BottomSheetTimePicker(
              initialTime: initialTime,
              textColor: pickerStyle.titleColor ?? ColorTokens.textDefault,
              backgroundColor:
                  pickerStyle.backgroundColor ?? ColorTokens.bgElevated,
              onChanged: (value) {
                selectedTime = value;
              },
            ),
          ),
    );
  }

  Widget _buildStyledPicker(BuildContext context, Widget? child) {
    final pickerStyle = _effectivePickerStyle;
    if (child == null) return const SizedBox();

    final theme = Theme.of(context);
    final selectedColor = pickerStyle.selectedColor;
    final selectedTextColor = pickerStyle.selectedTextColor;
    final titleColor = pickerStyle.titleColor;
    final headerBackgroundColor =
        pickerStyle.headerBackgroundColor ?? selectedColor;
    final headerForegroundColor =
        pickerStyle.headerForegroundColor ?? selectedTextColor;
    final colorScheme = theme.colorScheme.copyWith(
      primary: selectedColor,
      onPrimary: selectedTextColor,
      surface: pickerStyle.backgroundColor,
      onSurface: titleColor,
    );
    final actionTextColor = pickerStyle.actionTextColor ?? selectedColor;
    final dialogShape =
        pickerStyle.dialogBorderRadius == null
            ? null
            : RoundedRectangleBorder(
              borderRadius: pickerStyle.dialogBorderRadius!,
            );

    return Theme(
      data: theme.copyWith(
        colorScheme: colorScheme,
        datePickerTheme: theme.datePickerTheme.copyWith(
          backgroundColor: pickerStyle.backgroundColor,
          surfaceTintColor: pickerStyle.surfaceTintColor,
          shape: dialogShape,
          headerBackgroundColor: headerBackgroundColor,
          headerForegroundColor: headerForegroundColor,
          headerHelpStyle: pickerStyle.headerTitleTextStyle,
          headerHeadlineStyle: pickerStyle.headerHeadlineTextStyle,
        ),
        timePickerTheme: theme.timePickerTheme.copyWith(
          backgroundColor: pickerStyle.backgroundColor,
          shape: dialogShape,
          dialHandColor: selectedColor,
          entryModeIconColor: pickerStyle.entryModeIconColor,
          hourMinuteColor: selectedColor?.withAlpha(31),
          hourMinuteTextColor: titleColor,
          dayPeriodTextColor: titleColor,
          helpTextStyle:
              pickerStyle.headerTitleTextStyle ?? TextStyle(color: titleColor),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return null;
              return actionTextColor;
            }),
          ),
        ),
      ),
      child: child,
    );
  }

  AppDateTimePickerStyle get _effectivePickerStyle {
    final style = widget.pickerStyle;

    return AppDateTimePickerStyle(
      dateTitleText: style?.dateTitleText,
      timeTitleText: style?.timeTitleText,
      dateTimeTitleText: style?.dateTimeTitleText,
      cancelText: style?.cancelText,
      confirmText: style?.confirmText,
      selectedColor: style?.selectedColor ?? ColorTokens.primaryDefault,
      selectedTextColor: style?.selectedTextColor ?? ColorTokens.white,
      titleColor: style?.titleColor ?? ColorTokens.textDefault,
      headerBackgroundColor:
          style?.headerBackgroundColor ??
          style?.selectedColor ??
          ColorTokens.primaryDefault,
      headerForegroundColor:
          style?.headerForegroundColor ??
          style?.selectedTextColor ??
          ColorTokens.white,
      headerTitleTextStyle: style?.headerTitleTextStyle,
      headerHeadlineTextStyle: style?.headerHeadlineTextStyle,
      entryModeIconColor: style?.entryModeIconColor,
      dateSwitchToInputEntryModeIcon:
          style?.dateSwitchToInputEntryModeIcon ??
          _resolveEntryModeIcon(Icons.edit_outlined, style?.entryModeIconColor),
      dateSwitchToCalendarEntryModeIcon:
          style?.dateSwitchToCalendarEntryModeIcon ??
          _resolveEntryModeIcon(
            Icons.calendar_today_outlined,
            style?.entryModeIconColor,
          ),
      backgroundColor: style?.backgroundColor,
      surfaceTintColor: style?.surfaceTintColor,
      actionTextColor:
          style?.actionTextColor ??
          style?.selectedColor ??
          ColorTokens.primaryDefault,
      dialogBorderRadius: style?.dialogBorderRadius,
    );
  }

  bool get _usesBottomSheetPicker =>
      widget.pickerPresentation == AppDateTimePickerPresentation.bottomSheet;

  String get _dateBottomSheetTitle =>
      _effectivePickerStyle.dateTitleText ?? 'Select date';

  String get _timeBottomSheetTitle =>
      _effectivePickerStyle.timeTitleText ?? 'Select time';

  String get _dateTimeBottomSheetTitle =>
      _effectivePickerStyle.dateTimeTitleText ?? 'Select date and time';

  String get _dateBottomSheetSectionTitle => 'Date';

  String get _timeBottomSheetSectionTitle => 'Time';

  Widget _buildBottomSheetSectionLabel(String text) {
    return AppText(
      text: text,
      size: AppTextSize.bodyMBold,
      color: _effectivePickerStyle.titleColor ?? ColorTokens.textDefault,
    );
  }

  Icon? _resolveEntryModeIcon(IconData icon, Color? color) {
    if (color == null) return null;

    return Icon(icon, color: color);
  }

  DateTime _clampDate(DateTime value, DateTime firstDate, DateTime lastDate) {
    if (value.isBefore(firstDate)) return firstDate;
    if (value.isAfter(lastDate)) return lastDate;

    return value;
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

class _BottomSheetTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onChanged;
  final Color textColor;
  final Color backgroundColor;

  const _BottomSheetTimePicker({
    required this.initialTime,
    required this.onChanged,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  State<_BottomSheetTimePicker> createState() => _BottomSheetTimePickerState();
}

class _BottomSheetTimePickerState extends State<_BottomSheetTimePicker> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = _resolveInitialDateTime(widget.initialTime);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text:
                '${_twoDigits(_selectedDateTime.hour)}:${_twoDigits(_selectedDateTime.minute)}',
            size: AppTextSize.heading4Bold,
            color: widget.textColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SpacingTokens.spaceM),
          SizedBox(
            height: 216,
            child: CupertinoTheme(
              data: CupertinoTheme.of(context).copyWith(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    color: widget.textColor,
                    fontSize: TypographyTokens.heading4FontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                backgroundColor: widget.backgroundColor,
                initialDateTime: _selectedDateTime,
                onDateTimeChanged: (value) {
                  setState(() {
                    _selectedDateTime = value;
                  });
                  widget.onChanged(TimeOfDay.fromDateTime(value));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _resolveInitialDateTime(TimeOfDay value) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, value.hour, value.minute);
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
