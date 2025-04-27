import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/config/database_service.dart';
import 'package:my_app/constants/app_colors.dart';

// Enum for theme modes
enum AppThemeMode { light, dark, custom }

// Theme state class
class ThemeState {
  final AppThemeMode mode;
  final Color backgroundColor;
  final Color primaryColor;
  final Color secondaryColor;

  ThemeState({
    required this.mode,
    this.backgroundColor = Colors.white,
    this.primaryColor = Colors.red,
    this.secondaryColor = Colors.redAccent,
  });

  ThemeState copyWith({
    AppThemeMode? mode,
    Color? backgroundColor,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }
}

// Theme provider using StateNotifier
class ThemeNotifier extends StateNotifier<ThemeState> {
  final DatabaseService _databaseService;

  ThemeNotifier(this._databaseService)
      : super(ThemeState(mode: AppThemeMode.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeData = await _databaseService.getTheme();
    if (themeData != null) {
      final mode = AppThemeMode.values.firstWhere(
        (e) => e.toString().split('.').last == themeData['themeMode'],
        orElse: () => AppThemeMode.light,
      );
      state = ThemeState(
        mode: mode,
        backgroundColor: themeData['backgroundColor'] != null
            ? Color(themeData['backgroundColor'])
            : Colors.white,
        primaryColor: themeData['primaryColor'] != null
            ? Color(themeData['primaryColor'])
            : Colors.red,
        secondaryColor: themeData['secondaryColor'] != null
            ? Color(themeData['secondaryColor'])
            : Colors.redAccent,
      );
    }
  }

  Future<void> _saveTheme() async {
    await _databaseService.saveTheme(
      themeMode: state.mode.toString().split('.').last,
      backgroundColor: state.mode == AppThemeMode.custom
          ? state.backgroundColor.value
          : null,
      primaryColor:
          state.mode == AppThemeMode.custom ? state.primaryColor.value : null,
      secondaryColor:
          state.mode == AppThemeMode.custom ? state.secondaryColor.value : null,
    );
  }

  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(mode: mode);
    _saveTheme();
  }

  void setCustomColors({
    Color? backgroundColor,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    state = state.copyWith(
      mode: AppThemeMode.custom,
      backgroundColor: backgroundColor,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
    _saveTheme();
  }

  ThemeData get themeData {
    switch (state.mode) {
      case AppThemeMode.light:
        return lightTheme; // Use lightTheme from constants.dart
      case AppThemeMode.dark:
        return darkTheme; // Use darkTheme from constants.dart
      case AppThemeMode.custom:
        print("custom theme");
        return ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            background: state.backgroundColor,
            primary: state.primaryColor,
            secondary: state.secondaryColor,
          ),
        );
    }
  }
}

// Riverpod provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier(DatabaseService());
});
