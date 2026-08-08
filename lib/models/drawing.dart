import 'package:flutter/material.dart';

/// Tek bir fırça darbesi (parmağın basılı tutulduğu andan kalkana kadar).
/// Nokta listesi olarak tutulur — bitmap DEĞİL.
/// "Çocuğun çizimi asla değişmez" ilkesi teknik olarak burada başlar:
/// orijinal noktalar hiçbir zaman yeniden üretilmez, sadece dönüştürülür
/// (taşıma/döndürme/ölçekleme) — CustomPainter her zaman bu ham noktalardan çizer.
class DrawingStroke {
  DrawingStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawingStroke copyWith({List<Offset>? points}) {
    return DrawingStroke(
      points: points ?? this.points,
      color: color,
      strokeWidth: strokeWidth,
    );
  }
}

/// Tüm çizim: birden çok stroke'un sıralı listesi.
class Drawing {
  Drawing({List<DrawingStroke>? strokes}) : strokes = strokes ?? [];

  final List<DrawingStroke> strokes;

  bool get isEmpty => strokes.isEmpty;

  /// Çizimin kapladığı alan — animasyonlarda merkez/ölçek hesaplamak için.
  Rect get boundingBox {
    if (strokes.isEmpty) return Rect.zero;
    double minX = double.infinity, minY = double.infinity;
    double maxX = -double.infinity, maxY = -double.infinity;
    for (final stroke in strokes) {
      for (final p in stroke.points) {
        if (p.dx < minX) minX = p.dx;
        if (p.dy < minY) minY = p.dy;
        if (p.dx > maxX) maxX = p.dx;
        if (p.dy > maxY) maxY = p.dy;
      }
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
