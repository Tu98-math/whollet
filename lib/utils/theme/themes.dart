import 'package:flutter/material.dart';
import 'package:whollet/constants/app_colors.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.kBackgroundColor,
    fontFamily: 'Titillium Web',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: inputDecorationTheme(),
    appBarTheme: appBarTheme(),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    alignLabelWithHint: true,
    hintStyle: TextStyle(
      color: Color(0xFF3D4C63),
      fontSize: 16,
    ),
    labelStyle: TextStyle(
      fontSize: 15,
      color: Color(0xFFB5BBC9),
      fontWeight: FontWeight.w600,
    ),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    backgroundColor: AppColors.kBackgroundColor,
    elevation: 0,
    brightness: Brightness.light,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Color(0xFF0D1F3C),
        fontWeight: FontWeight.w600,
        fontSize: 26,
      ),
    ),
    centerTitle: true,
  );
}
