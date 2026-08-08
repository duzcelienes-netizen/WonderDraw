import 'package:flutter/material.dart';
import '../models/drawing.dart';
import '../models/wonder_object.dart';
import '../theme/app_theme.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/toolbar.dart';
import 'object_selection_screen.dart';
import 'magic_moment_screen.dart';

/// Uygulamanın tek ve doğrudan açılan ekranı.
/// PRD: "Hiçbir Splash Screen yoktur. Hiçbir giriş ekranı yoktur.
/// Hiçbir menü yoktur. Çocuk doğrudan boş tuvali görür."
class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  final Drawing _drawing = Drawing();
  final List<DrawingStroke> _redoBuffer = [];

  DrawTool _tool = DrawTool.pen;
  Color _activeColor = WonderColors.brushPalette.first;
  double _strokeWidth = 10;

  bool get _hasContent => _drawing.strokes.isNotEmpty;

  void _onDrawingChanged(Drawing updated) {
    // Yeni bir çizgi eklendiğinde redo geçmişi geçersiz olur — standart davranış.
    if (_redoBuffer.isNotEmpty) _redoBuffer.clear();
    setState(() {});
  }

  void _undo() {
    if (_drawing.strokes.isEmpty) return;
    setState(() {
      _redoBuffer.add(_drawing.strokes.removeLast());
    });
  }

  void _redo() {
    if (_redoBuffer.isEmpty) return;
    setState(() {
      _drawing.strokes.add(_redoBuffer.removeLast());
    });
  }

  void _clear() {
    setState(() {
      _drawing.strokes.clear();
      _redoBuffer.clear();
    });
  }

  Color get _effectiveDrawColor =>
      _tool == DrawTool.eraser ? WonderColors.canvasBackground : _activeColor;

  double get _effectiveStrokeWidth => _tool == DrawTool.eraser ? 26 : _strokeWidth;

  Future<void> _openObjectSelection() async {
    final selectedType = await Navigator.of(context).push<WonderObjectType>(
      MaterialPageRoute(
        builder: (_) => ObjectSelectionScreen(
          onSelected: (type) => Navigator.of(context).pop(type),
        ),
      ),
    );
    if (selectedType == null || !mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MagicMomentScreen(
          drawing: _drawing,
          objectType: selectedType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WonderColors.canvasBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Tuval, tüm ekranı kaplar.
            Positioned.fill(
              child: DrawingCanvas(
                drawing: _drawing,
                activeColor: _effectiveDrawColor,
                strokeWidth: _effectiveStrokeWidth,
                onDrawingChanged: _onDrawingChanged,
              ),
            ),

            // Araç çubuğu, üstte.
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: WonderToolbar(
                activeTool: _tool,
                activeColor: _activeColor,
                canUndo: _drawing.strokes.isNotEmpty,
                canRedo: _redoBuffer.isNotEmpty,
                onToolChanged: (tool) => setState(() => _tool = tool),
                onColorChanged: (color) => setState(() {
                  _activeColor = color;
                  _tool = DrawTool.pen;
                }),
                onUndo: _undo,
                onRedo: _redo,
                onClear: _clear,
              ),
            ),

            // "✨ Canlandır" butonu — çocuk çizime başladığında kendiliğinden belirir.
            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  offset: _hasContent ? Offset.zero : const Offset(0, 2),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _hasContent ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: !_hasContent,
                      child: ElevatedButton(
                        onPressed: _openObjectSelection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WonderColors.sunYellow,
                          foregroundColor: WonderColors.ink,
                        ),
                        child: const Text(
                          '✨ Canlandır ✨',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
