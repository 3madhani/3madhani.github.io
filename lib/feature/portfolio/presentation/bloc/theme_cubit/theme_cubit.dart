import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  static const String _themeModeKey = 'theme_mode';
  static const String _seedColorKey = 'seed_color';

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final themeModeString = prefs.getString(_themeModeKey);
    ThemeMode themeMode = ThemeMode.system;
    bool isSystemMode = true;

    if (themeModeString != null) {
      switch (themeModeString) {
        case 'light':
          themeMode = ThemeMode.light;
          isSystemMode = false;
          break;
        case 'dark':
          themeMode = ThemeMode.dark;
          isSystemMode = false;
          break;
        default:
          themeMode = ThemeMode.system;
          isSystemMode = true;
      }
    }

    // Load seed color
    final colorValue = prefs.getInt(_seedColorKey);
    final seedColor = colorValue != null
        ? Color(colorValue)
        : const Color(0xFF1FB8CD);

    emit(
      state.copyWith(
        themeMode: themeMode,
        seedColor: seedColor,
        isSystemMode: isSystemMode,
      ),
    );
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    ThemeMode newMode;
    bool newIsSystemMode;

    switch (state.themeMode) {
      case ThemeMode.system:
        newMode = ThemeMode.light;
        newIsSystemMode = false;
        await prefs.setString(_themeModeKey, 'light');
        break;
      case ThemeMode.light:
        newMode = ThemeMode.dark;
        newIsSystemMode = false;
        await prefs.setString(_themeModeKey, 'dark');
        break;
      case ThemeMode.dark:
        newMode = ThemeMode.system;
        newIsSystemMode = true;
        await prefs.remove(_themeModeKey);
        break;
    }

    emit(state.copyWith(themeMode: newMode, isSystemMode: newIsSystemMode));
  }

  Future<void> updateSeedColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_seedColorKey, color.value);

    emit(state.copyWith(seedColor: color));
  }

  String get themeIcon {
    switch (state.themeMode) {
      case ThemeMode.light:
        return 'light_mode';
      case ThemeMode.dark:
        return 'dark_mode';
      case ThemeMode.system:
        return 'brightness_auto';
    }
  }
}
