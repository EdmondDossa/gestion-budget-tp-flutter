
import 'package:flutter/material.dart';

enum AppTheme { dark, light }

final Map<AppTheme, ThemeData> appThemes = {
  AppTheme.dark: ThemeData.dark(useMaterial3: true),
  
  AppTheme.light: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2962FF)),
    useMaterial3: true,
  ),
};