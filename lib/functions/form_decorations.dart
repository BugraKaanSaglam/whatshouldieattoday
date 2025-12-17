//* Decorations
import 'package:flutter/material.dart';

import '../global/app_theme.dart';

InputDecoration formDecoration() {
  final OutlineInputBorder baseBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.blueGrey.shade100));
  return InputDecoration(
    labelStyle: formTextStyle(textColor: const Color(0xFF4B5563)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    floatingLabelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.seedColor),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.85),
    border: baseBorder,
    enabledBorder: baseBorder,
    focusedBorder: baseBorder.copyWith(borderSide: const BorderSide(color: AppTheme.seedColor, width: 1.6)),
    errorBorder: baseBorder.copyWith(borderSide: const BorderSide(color: Colors.redAccent)),
  );
}

BoxDecoration switchDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white,
    border: const Border.fromBorderSide(BorderSide(color: Colors.blueGrey)),
  );
}

TextStyle formTextStyle({Color textColor = Colors.black, double fontSize = 16}) => TextStyle(color: textColor, fontSize: fontSize, height: 1.4);
TextStyle buttonTextStyle({Color textColor = Colors.white, double fontSize = 14}) => TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w600);
