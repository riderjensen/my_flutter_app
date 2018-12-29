import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
  primarySwatch: Colors.grey,
  accentColor: Colors.teal,
  brightness: Brightness.dark,
  buttonColor: Colors.teal,
);

final ThemeData _iOSTheme = ThemeData(
  primarySwatch: Colors.grey,
  accentColor: Colors.blue,
  brightness: Brightness.light,
  buttonColor: Colors.blue,
);

ThemeData getAdaptiveThemeData(context) {
  return Theme.of(context).platform == TargetPlatform.android
      ? _androidTheme
      : _iOSTheme;
}
