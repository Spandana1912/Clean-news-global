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
    if (_language == value) return;
    _language = value;
    notifyListeners();
  }
}

/// Makes the [SettingsController] available to every screen below the
/// MaterialApp's Navigator. Any widget that calls [SettingsScope.of]
/// (directly or through `AppStrings.of(context)`) is rebuilt automatically
/// whenever a setting such as the language changes.
class SettingsScope extends InheritedNotifier<SettingsController> {
  const SettingsScope({
    super.key,
    required SettingsController controller,
    required super.child,
  }) : super(notifier: controller);

  static SettingsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SettingsScope>();
    assert(scope != null, 'SettingsScope not found above this widget.');
    return scope!.notifier!;
  }
}