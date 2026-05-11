import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

part 'app_date_time_field_config.dart';
part 'app_date_time_field_formatting.dart';
part 'app_date_time_field_picker.dart';

class AppDateTimeField extends StatefulWidget {
  final AppDateTimeFieldMode mode;
  final DateTime? value;
  final TimeOfDay? timeValue;
  final ValueChanged<DateTime?>? onChanged;
  final ValueChanged<TimeOfDay?>? onTimeChanged;
  final AppTextFieldVariant variant;
  final AppTextFieldSize size;
  final bool isRounded;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final AppTextSize? errorTextSize;
  final bool isDisabled;
  final bool isRequired;
  final bool isOptional;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialPickerDate;
  final TimeOfDay? initialPickerTime;
  final AppDatePicker? datePicker;
  final AppTimePicker? timePicker;
  final AppDateFormatter? dateFormatter;
  final AppTimeFormatter? timeFormatter;
  final AppDateTimeFormatter? dateTimeFormatter;
  final AppDateTimePickerStyle? pickerStyle;
  final AppDateTimePickerPresentation pickerPresentation;
  final DatePickerEntryMode initialDatePickerEntryMode;
  final TimePickerEntryMode initialTimePickerEntryMode;
  final SelectableDayPredicate? selectableDayPredicate;

  const AppDateTimeField({
    super.key,
    this.mode = AppDateTimeFieldMode.date,
    this.value,
    this.timeValue,
    this.onChanged,
    this.onTimeChanged,
    this.variant = AppTextFieldVariant.primary,
    this.size = AppTextFieldSize.medium,
    this.isRounded = false,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.errorTextSize,
    this.isDisabled = false,
    this.isRequired = false,
    this.isOptional = false,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.focusNode,
    this.autofocus = false,
    this.firstDate,
    this.lastDate,
    this.initialPickerDate,
    this.initialPickerTime,
    this.datePicker,
    this.timePicker,
    this.dateFormatter,
    this.timeFormatter,
    this.dateTimeFormatter,
    this.pickerStyle,
    this.pickerPresentation = AppDateTimePickerPresentation.dialog,
    this.initialDatePickerEntryMode = DatePickerEntryMode.calendar,
    this.initialTimePickerEntryMode = TimePickerEntryMode.dial,
    this.selectableDayPredicate,
  });

  @override
  State<AppDateTimeField> createState() => _AppDateTimeFieldState();
}

class _AppDateTimeFieldState extends State<AppDateTimeField> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _syncSelectionFromWidget();
    _syncText();
  }

  @override
  void didUpdateWidget(covariant AppDateTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value ||
        oldWidget.timeValue != widget.timeValue ||
        oldWidget.mode != widget.mode) {
      _syncSelectionFromWidget();
      _syncText();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.isDisabled) return;

    switch (widget.mode) {
      case AppDateTimeFieldMode.date:
        await _pickDate();
        return;
      case AppDateTimeFieldMode.time:
        await _pickTime();
        return;
      case AppDateTimeFieldMode.dateTime:
        await _pickDateTime();
        return;
    }
  }

  Future<void> _pickDate() async {
    final selectedDate = await _showDatePicker();
    if (!mounted || selectedDate == null) return;

    setState(() {
      _selectedDate = _dateOnly(selectedDate);
      _syncText();
    });
    widget.onChanged?.call(_selectedDate);
  }

  Future<void> _pickTime() async {
    final selectedTime = await _showTimePicker();
    if (!mounted || selectedTime == null) return;

    setState(() {
      _selectedTime = selectedTime;
      _syncText();
    });
    widget.onTimeChanged?.call(_selectedTime);
  }

  Future<void> _pickDateTime() async {
    if (widget.datePicker == null &&
        widget.timePicker == null &&
        widget.pickerPresentation ==
            AppDateTimePickerPresentation.bottomSheet) {
      final selectedDateTime = await _showBottomSheetDateTimePicker();
      if (!mounted || selectedDateTime == null) return;

      final selectedTime = TimeOfDay.fromDateTime(selectedDateTime);

      setState(() {
        _selectedDate = selectedDateTime;
        _selectedTime = selectedTime;
        _syncText();
      });
      widget.onChanged?.call(selectedDateTime);
      widget.onTimeChanged?.call(selectedTime);
      return;
    }

    final selectedDate = await _showDatePicker();
    if (!mounted || selectedDate == null) return;

    final selectedTime = await _showTimePicker();
    if (!mounted || selectedTime == null) return;

    final nextValue = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      _selectedDate = nextValue;
      _selectedTime = selectedTime;
      _syncText();
    });
    widget.onChanged?.call(nextValue);
    widget.onTimeChanged?.call(selectedTime);
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      focusNode: widget.focusNode,
      onTap: _handleTap,
      variant: widget.variant,
      size: widget.size,
      isRounded: widget.isRounded,
      hintText: _hintText,
      labelText: widget.labelText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      errorTextSize: widget.errorTextSize,
      isDisabled: widget.isDisabled,
      isReadOnly: true,
      isRequired: widget.isRequired,
      isOptional: widget.isOptional,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _suffixIcon,
      prefix: widget.prefix,
      suffix: widget.suffix,
      floatingLabelBehavior: widget.floatingLabelBehavior,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.none,
    );
  }
}
