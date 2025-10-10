import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final Color seedColor;
  final bool isSystemMode;

  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.seedColor = const Color(0xFF1FB8CD),
    this.isSystemMode = true,
  });

  @override
  List<Object?> get props => [themeMode, seedColor, isSystemMode];

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
    bool? isSystemMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      isSystemMode: isSystemMode ?? this.isSystemMode,
    );
  }
}
