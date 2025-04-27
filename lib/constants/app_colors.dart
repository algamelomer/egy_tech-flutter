import 'package:flutter/material.dart';

// Light theme color scheme
var lightThemeColorScheme = ColorScheme.light(
  background: Colors.white,
  primary: Colors.black,
  secondary: Colors.grey,
);

// Dark theme color scheme
var darkThemeColorScheme = ColorScheme.dark(
  background: Colors.grey[900] ?? Colors.grey,
  primary: Colors.white,
  secondary: Colors.grey[300] ?? Colors.grey,
);

// Light theme data
final lightTheme = ThemeData.light().copyWith(
  colorScheme: lightThemeColorScheme,
);

// Dark theme data
final darkTheme = ThemeData.dark().copyWith(
  colorScheme: darkThemeColorScheme,
);