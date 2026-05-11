part of 'app_date_time_field.dart';

extension _AppDateTimeFieldFormatting on _AppDateTimeFieldState {
  void _syncSelectionFromWidget() {
    _selectedDate = widget.value;
    _selectedTime =
        widget.timeValue ??
        (widget.value == null ? null : TimeOfDay.fromDateTime(widget.value!));

    if (widget.mode == AppDateTimeFieldMode.dateTime &&
        widget.value != null &&
        widget.timeValue != null) {
      _selectedDate = DateTime(
        widget.value!.year,
        widget.value!.month,
        widget.value!.day,
        widget.timeValue!.hour,
        widget.timeValue!.minute,
      );
    }
  }

  void _syncText() {
    final text = _resolveText();
    if (_controller.text == text) return;

    _controller.text = text;
  }

  String _resolveText() {
    switch (widget.mode) {
      case AppDateTimeFieldMode.date:
        final value = _selectedDate;
        return value == null ? '' : _formatDate(value);
      case AppDateTimeFieldMode.time:
        final value = _selectedTime;
        return value == null ? '' : _formatTime(value);
      case AppDateTimeFieldMode.dateTime:
        final value = _selectedDate;
        return value == null ? '' : _formatDateTime(value);
    }
  }

  String _formatDate(DateTime value) {
    return widget.dateFormatter?.call(value) ??
        '${_twoDigits(value.day)}/${_twoDigits(value.month)}/${_fourDigits(value.year)}';
  }

  String _formatTime(TimeOfDay value) {
    return widget.timeFormatter?.call(value) ??
        '${_twoDigits(value.hour)}:${_twoDigits(value.minute)}';
  }

  String _formatDateTime(DateTime value) {
    return widget.dateTimeFormatter?.call(value) ??
        '${_formatDate(value)} ${_formatTime(TimeOfDay.fromDateTime(value))}';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _fourDigits(int value) => value.toString().padLeft(4, '0');

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  String get _hintText {
    if (widget.hintText?.isNotEmpty == true) return widget.hintText!;

    switch (widget.mode) {
      case AppDateTimeFieldMode.date:
        return 'Select date DD/MM/YYYY';
      case AppDateTimeFieldMode.time:
        return 'Select time HH:MM';
      case AppDateTimeFieldMode.dateTime:
        return 'Select date DD/MM/YYYY HH:MM';
    }
  }

  Widget get _suffixIcon {
    if (widget.suffixIcon != null) return widget.suffixIcon!;

    switch (widget.mode) {
      case AppDateTimeFieldMode.time:
        return const Icon(Icons.access_time_outlined);
      case AppDateTimeFieldMode.date:
      case AppDateTimeFieldMode.dateTime:
        return const Icon(Icons.calendar_today_outlined);
    }
  }
}
