import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  bool _darkMode = false;

  bool _notificationsEnabled = true;

  double _textScale = 1.0;

  String _language = "English";

  bool get darkMode => _darkMode;

  bool get notificationsEnabled => _notificationsEnabled;

  double get textScale => _textScale;

  String get language => _language;

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setTextScale(double value) {
    _textScale = value;
    notifyListeners();
  }

  void setLanguage(String value) {
    _language = value;
    notifyListeners();
  }
}
