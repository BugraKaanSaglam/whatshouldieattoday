import 'package:flutter/material.dart';

class SizerMediaQuery {
  static double getW(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getH(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static TextScaler getText(BuildContext context) {
    return MediaQuery.of(context).textScaler;
  }
}
