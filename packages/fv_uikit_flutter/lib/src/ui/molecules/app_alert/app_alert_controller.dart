part of 'app_alert.dart';

class AppAlertController {
  VoidCallback? _close;
  bool _isOpen = false;

  AppAlertController._();

  bool get isOpen => _isOpen;

  void close() {
    _close?.call();
  }
}
