import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFF5F9FD),
  primaryColor: const Color(0xFF0C54BE),
  fontFamily: "Poppins",
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0C54BF),
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF0C54BE),
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
);


class CustomColors{
  static Color grey = const Color(0xffCED3DC);
}