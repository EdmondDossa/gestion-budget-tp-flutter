
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum AppTheme { dark, light }

final Map<AppTheme, ShadThemeData> appThemes = {
  AppTheme.dark: ShadThemeData(
    brightness: Brightness.dark,
    colorScheme: const ShadSlateColorScheme.dark(),
    primaryButtonTheme: const ShadButtonTheme(),
  ),
  AppTheme.light: ShadThemeData(
    brightness: Brightness.light,
    colorScheme: const ShadSlateColorScheme.light(),
    primaryButtonTheme: const ShadButtonTheme(),
  )
};