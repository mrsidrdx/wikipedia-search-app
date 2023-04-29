import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

ThemeMode getThemeMode(String? themeMode) {
  switch (themeMode) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

bool checkIsDarkMode(BuildContext context, ThemeMode themeMode) {
  if (themeMode == ThemeMode.light) {
    return false;
  } else if (themeMode == ThemeMode.system &&
      MediaQuery.of(context).platformBrightness == Brightness.light) {
    return false;
  }
  return true;
}

Future<void> openWebPage(int pageId) async {
  final Uri _url = Uri.parse('https://en.wikipedia.org/?curid=$pageId');
  if (!await launchUrl(_url, mode: LaunchMode.inAppWebView)) {
    throw Exception('Could not launch $_url');
  }
}
