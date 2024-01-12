import 'package:flutter/material.dart';
import 'package:myapp/theme/light_mode.dart';
import 'package:myapp/theme/dark_mode.dart';



class ThemeProvider extends ChangeNotifier {
  
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
  }

  changeTheme(bool value) {}
}