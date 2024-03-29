import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:newsbites/bloc/theme/theme.dart';
import 'package:newsbites/bloc/theme/theme_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeSwitcherEvent, ThemeData> {
  ThemeBloc() : super(lightMode) {
    on<SetInitialTheme>((event, emit) async {
      bool hasThemeDark = await isDark();
      emit(hasThemeDark ? darkMode : lightMode);
    });
    on<ThemeSwitching>((event, emit) async {
      bool hasThemeDark = state == darkMode;
      emit(hasThemeDark ? lightMode : darkMode);
      setTheme(hasThemeDark);
    });
  }
}

Future<bool> isDark() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  return sharedPreferences.getBool('is_dark') ?? false;
}

Future<void> setTheme(bool isDark) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  sharedPreferences.setBool('is_dark', isDark);
}
