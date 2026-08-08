import 'package:flutter/material.dart';

/// WonderDraw tasarım dili:
/// "Apple kadar temiz, Disney kadar sıcak, Pixar kadar canlı."
/// Pastel renkler, yuvarlak köşeler, büyük boşluklar, yumuşak gölgeler.
class WonderColors {
  WonderColors._();

  static const canvasBackground = Color(0xFFFFFBF2); // sıcak krem
  static const skyBlue = Color(0xFFAEE3F5);
  static const sunYellow = Color(0xFFFFD86B);
  static const leafGreen = Color(0xFF9BD6A0);
  static const coral = Color(0xFFFF9E80);
  static const lavender = Color(0xFFCBB8F0);
  static const ink = Color(0xFF3A3A3A);
  static const softShadow = Color(0x22000000);

  /// Çocuğun çizim yapabileceği fırça renk paleti.
  static const List<Color> brushPalette = [
    Color(0xFF3A3A3A), // siyah/kömür
    Color(0xFFE85D5D), // kırmızı
    Color(0xFFFFA940), // turuncu
    Color(0xFFFFD86B), // sarı
    Color(0xFF9BD6A0), // yeşil
    Color(0xFF6FB7E8), // mavi
    Color(0xFFCBB8F0), // mor
    Color(0xFFFF8FC7), // pembe
    Color(0xFF8D6E63), // kahverengi
  ];
}

class WonderRadii {
  WonderRadii._();
  static const button = 28.0;
  static const card = 24.0;
  static const sheet = 32.0;
}

ThemeData buildWonderDrawTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rounded', // proje fontu ekleyince değiştirin; yoksa sistem varsayılanı kullanılır
    colorScheme: ColorScheme.fromSeed(
      seedColor: WonderColors.sunYellow,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: WonderColors.canvasBackground,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: WonderColors.ink,
      displayColor: WonderColors.ink,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WonderRadii.button),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        elevation: 4,
        shadowColor: WonderColors.softShadow,
      ),
    ),
  );
}
