import 'package:flutter/material.dart';
import '/helpers/colors.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
      primarySwatch: MyColors.colors,
      brightness: Brightness.light,
      textTheme: const TextTheme(
        bodyText2: TextStyle(fontSize: 18),
        subtitle1: TextStyle(fontSize: 14),
        headline1: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      iconTheme: const IconThemeData(size: 30),
      scaffoldBackgroundColor: MyColors.colors[300],
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: MyColors.colors[200])),
      appBarTheme: AppBarTheme(color: MyColors.colors[100]));
}
