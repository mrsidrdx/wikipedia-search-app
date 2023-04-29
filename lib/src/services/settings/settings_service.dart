import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikipedia_search_app/src/commons/utils.dart';

class SettingsService {
  /// Loads the User's preferred ThemeMode from local storage.
  Future<ThemeMode> themeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? themeModeString = prefs.getString('themeMode');
    return getThemeMode(themeModeString);
  }

  /// Persists the user's preferred ThemeMode to local storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String themeModeString = describeEnum(theme);
    await prefs.setString('themeMode', themeModeString);
  }
}
