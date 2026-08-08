import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../animation/magic_controller.dart';
import '../audio/sound_service.dart';
import '../models/drawing.dart';
import '../models/wonder_object.dart';
import '../models/wonder_object_registry.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_wonder_object.dart';

/// Ürünün kalbi. PRD'deki sıra:
/// ✨ parıltılar → 📳 hafif titreşim → 🎵 kısa ses → çizimin hafif nefes
/// alması → ~1 sn bekleme → canlanma.
/// M2'den itibaren bu sıralamanın gerçek yürütücüsü MagicController'dır —
/// bu ekran sadece görsel katmanı (parıltı/nefes çizimi) barındırır.
class MagicMomentScreen extends StatefulWidget {
  const MagicMomentScreen({
    super.key,
    required this.drawing,
    required this.objectType,
    this.soundService = const SilentSoundService(),
  });

  final Drawing drawing;
  final WonderObjectType objectType;
  final SoundService soundService;

  @override
  State<MagicMomentScreen> createState() => _MagicMomentScreenState();
}

class _MagicMomentScreenState extends State<MagicMomentScreen>
    with TickerProviderStateMixin {
  late final MagicController _magic = MagicController(
    vsync: this,
    soundService: widget.soundService,
  );
  late final AnimationController _breatheController;
  late final behavior = WonderObjectRegistry.behaviorFor(widget.objectType);

  bool _revealed = false;

  @override
  void initState() {
    super.initState();

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _magic.playRevealSequence(spec: behavior.magicAnimation).then((_) {
      if (!mounted) return;
      setState(() => _revealed = true);
    });
  }

  @override
  void dispose() {
    _magic.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WonderColors.canvasBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 320,
                height: 320,
                child: _revealed
                    ? AnimatedWonderObject(
                        // Registry, özel karakteri olmayan nesneler için bile
                        // nazik bir jenerik davranış döner (bkz. WonderObjectRegistry._generic)
                        // — bu yüzden burada artık ayrı bir "yakında" dalına gerek yok;
                        // "aynı mimari kullanılarak daha sonra geliştirilsin" ilkesi
                        // şimdiden gerçek: hepsi aynı widget'tan geçiyor.
                        drawing: widget.drawing,
                        objectType: widget.objectType,
                        soundService: widget.soundService,
                      )
                    : AnimatedBuilder(
                        animation: _breatheController,
                        builder: (context, child) {
                          final breathe = 1.0 + _breatheController.value * 0.03;
                          return Transform.scale(scale: breathe, child: child);
                        },
                        child: CustomPaint(
                          painter: _StillDrawingPainter(widget.drawing),
                          size: Size.infinite,
                        ),
                      ),
              ),
            ),
            if (!_revealed)
              IgnorePointer(
                child: AnimatedBuilder(
                  animation: _magic.anticipationController,
                  builder: (context, _) => CustomPaint(
                    painter: _SparklePainter(
                      progress: _magic.anticipationController.value,
                      intensity: behavior.magicAnimation.glowIntensity,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            if (_revealed)
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    icon: const Icon(Icons.brush_rounded),
                    label: const Text('Bir tane daha çizeyim'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StillDrawingPainter extends CustomPainter {
  _StillDrawingPainter(this.drawing);
  final Drawing drawing;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in drawing.strokes) {
      if (stroke.points.length < 2) continue;
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
  bool shouldRepaint(covariant _StillDrawingPainter oldDelegate) => false;
}

/// Büyü anındaki ✨ parıltı tozları. `intensity`, nesnenin
/// `MagicAnimationSpec.glowIntensity` değerinden gelir — örn. güneş/yıldız
/// daha yoğun parlar, diğerleri daha sade bir parıltı alır.
class _SparklePainter extends CustomPainter {
  _SparklePainter({required this.progress, this.intensity = 0.4});
  final double progress;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final random = math.Random(7); // sabit seed: her seferinde aynı desen, kararlı görünüm
    final sparkleCount = 12 + (intensity * 12).round();
    for (int i = 0; i < sparkleCount; i++) {
      final angle = (i / sparkleCount) * 2 * math.pi;
      final radius = 90 + random.nextDouble() * 60;
      final orbit = progress * (0.6 + random.nextDouble() * 0.4);
      final pos = center +
          Offset(math.cos(angle + progress * 4) * radius * orbit,
              math.sin(angle + progress * 4) * radius * orbit);
      final opacity = (math.sin(progress * math.pi) * (0.5 + intensity)).clamp(0.0, 1.0);
      canvas.drawCircle(
        pos,
        3 + random.nextDouble() * 3,
        Paint()..color = WonderColors.sunYellow.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.intensity != intensity;
}
