import 'package:flutter/material.dart';
import 'screens/canvas_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const WonderDrawApp());
}

class WonderDrawApp extends StatelessWidget {
  const WonderDrawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WonderDraw',
      debugShowCheckedModeBanner: false,
      theme: buildWonderDrawTheme(),
      // Uygulama doğrudan tuvale açılır — splash/menü/login yok.
      home: const CanvasScreen(),
    );
  }
}
