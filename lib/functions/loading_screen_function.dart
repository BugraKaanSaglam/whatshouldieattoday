// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../main.dart';

Widget loadingScreen(BuildContext context) {
  return Scaffold(
    backgroundColor: MainAppState().foodApplicationTheme.colorScheme.background.withAlpha(200),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(child: CircularProgressIndicator(strokeWidth: 6, valueColor: AlwaysStoppedAnimation<Color>(MainAppState().foodApplicationTheme.colorScheme.surface))),
          const SizedBox(height: 20),
          const Text('Yükleniyor...', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
