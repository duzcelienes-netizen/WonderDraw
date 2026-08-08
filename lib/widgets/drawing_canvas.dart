import 'package:flutter/material.dart';
import '../models/drawing.dart';

/// Serbest çizim tuvali. Parmağın her hareketi bir DrawingStroke'a
/// dönüştürülüp `onDrawingChanged` ile dışarı bildirilir.
/// Hiçbir çizgi yorumlanmaz, düzeltilmez, "tanınmaya" çalışılmaz —
/// sadece kaydedilir.
class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({
    super.key,
    required this.drawing,
    required this.activeColor,
    required this.strokeWidth,
    required this.onDrawingChanged,
  });

  final Drawing drawing;
  final Color activeColor;
  final double strokeWidth;
  final ValueChanged<Drawing> onDrawingChanged;

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  DrawingStroke? _activeStroke;

  void _startStroke(Offset point) {
    _activeStroke = DrawingStroke(
      points: [point],
      color: widget.activeColor,
      strokeWidth: widget.strokeWidth,
    );
    widget.drawing.strokes.add(_activeStroke!);
    widget.onDrawingChanged(widget.drawing);
  }

  void _extendStroke(Offset point) {
    if (_activeStroke == null) return;
    setState(() {
      _activeStroke!.points.add(point);
    });
    widget.onDrawingChanged(widget.drawing);
  }

  void _endStroke() {
    _activeStroke = null;
    widget.onDrawingChanged(widget.drawing);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) => _startStroke(details.localPosition),
      onPanUpdate: (details) => _extendStroke(details.localPosition),
      onPanEnd: (_) => _endStroke(),
      child: CustomPaint(
        painter: _DrawingPainter(widget.drawing),
        size: Size.infinite,
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  _DrawingPainter(this.drawing);

  final Drawing drawing;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in drawing.strokes) {
      if (stroke.points.length < 2) {
        // Tek nokta = küçük bir nokta çizimi (örn. göz).
        if (stroke.points.isNotEmpty) {
          canvas.drawCircle(
            stroke.points.first,
            stroke.strokeWidth / 2,
            Paint()..color = stroke.color,
          );
        }
        continue;
      }
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (final point in stroke.points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
