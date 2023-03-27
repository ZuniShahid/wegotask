import 'package:flutter/material.dart';

import 'colors.dart';

class InputDecorations {
  static InputDecoration inputDecorationNoBorder({hintText = ""}) =>
      InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          color: Colors.black.withOpacity(0.4),
        ),
      );

  static InputDecoration inputDecorationAllBorder({hintText = ""}) =>
      InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.hintColor,
        ),
        border: InputBorder.none,
      );
}
