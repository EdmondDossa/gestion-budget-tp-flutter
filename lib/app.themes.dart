
import 'package:flutter/material.dart';

enum AppTheme { dark, light }

final Map<AppTheme, ThemeData> appThemes = {
  AppTheme.dark: ThemeData.dark(useMaterial3: true).copyWith(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
      ),
    ),
  ),
  
  AppTheme.light: ThemeData.light(useMaterial3: true).copyWith(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
      ),
    ),
  ),
};