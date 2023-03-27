import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'colors.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    primaryColor: AppColors.primary,
    iconTheme: const IconThemeData(color: Colors.black),
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: const Color(0xffCBDCF8),
    hintColor: const Color(0xFF989898),
    highlightColor: const Color(0xffFCE192),
    hoverColor: const Color(0xff4285F4),
    focusColor: const Color(0xffA8DAB5),
    disabledColor: Colors.grey,
    cardColor: Colors.white,
    canvasColor: Colors.grey[50],
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 1000),
        backgroundColor: AppColors.primary,
        shadowColor: AppColors.primary.withOpacity(0.90),
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        fixedSize: Size(100.w, 6.h),
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 15,
        color: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Color(0xFF272F4B),
      elevation: 0.0,
    ),
    // textTheme: const TextTheme(
    //   headline1: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline2: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline3: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline4: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline5: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline6: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   subtitle1: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   subtitle2: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   bodyText1: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   bodyText2: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   button: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   caption: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   overline: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    // ),
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: Colors.grey),
    // colorScheme: const ColorScheme.light(secondary: Colors.red),
  );
  static final dark = ThemeData.dark().copyWith(
    primaryColor: AppColors.primary,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.black,
    indicatorColor: const Color(0xffCBDCF8),
    hintColor: const Color(0xFF989898),
    highlightColor: const Color(0xffFCE192),
    hoverColor: const Color(0xff4285F4),
    focusColor: const Color(0xffA8DAB5),
    disabledColor: Colors.grey,
    cardColor: Colors.white,
    canvasColor: Colors.grey[50],
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 1000),
        backgroundColor: AppColors.primary,
        shadowColor: AppColors.primary.withOpacity(0.90),
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        fixedSize: Size(100.w, 6.h),
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 15,
        color: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Color(0xFF272F4B),
      elevation: 0.0,
    ),
    // textTheme: const TextTheme(
    //   headline1: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline2: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline3: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline4: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline5: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   headline6: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   subtitle1: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   subtitle2: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   bodyText1: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   bodyText2: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   button: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   caption: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    //   overline: TextStyle(
    //     fontSize: 12,
    //     fontWeight: FontWeight.bold,
    //     letterSpacing: -1.5,
    //     color: Color(0xFF222222),
    //   ),
    // ),
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: Colors.grey),
  );
}
