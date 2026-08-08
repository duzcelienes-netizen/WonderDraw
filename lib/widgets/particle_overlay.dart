import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ParticleShape { circle, teardrop, puff, spark }

/// Tek bir parçacık efekti tanımı (yaprak dökülmesi, yağmur, duman, parıltı...).
/// Yeni bir nesne "kendi" parçacık efektine ihtiyaç duyarsa önce burada bir
/// ParticleShape/renk kombinasyonuyla karşılanıp karşılanamayacağına bakılır —
/// çoğu durumda yeni bir CustomPainter yazmaya gerek kalmaz.
class ParticleOverlay extends StatelessWidget {
  const ParticleOverlay({
    super.key,
    required this.progress, // 0.0 -> 1.0
    required this.shape,
    required this.color,
    this.count = 10,
    this.fallsDown = true,
    this.seed = 1,
  });

  final double progress;
  final ParticleShape shape;
  final Color color;
  final int count;
  final bool fallsDown; // true: yaprak/yağmur gibi düşer, false: duman/parıltı gibi yükselir/dağılır
  final int seed;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(
          progress: progress,
          shape: shape,
          color: color,
          count: count,
          fallsDown: fallsDown,
          seed: seed,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.progress,
    required this.shape,
    required this.color,
    required this.count,
    required this.fallsDown,
    required this.seed,
  });

  final double progress;
  final ParticleShape shape;
  final Color color;
  final int count;
  final bool fallsDown;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < count; i++) {
      final startX = center.dx + (random.nextDouble() - 0.5) * size.width * 0.6;
      final startY = center.dy + (random.nextDouble() - 0.5) * size.height * 0.4;
      final delay = i / count * 0.4;
      final localT = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);
      if (localT <= 0) continue;

      final travel = fallsDown ? localT * 60 : -localT * 50;
      final drift = math.sin(localT * math.pi * 2 + i) * 8;
      final opacity = fallsDown ? (1 - localT) : math.sin(localT * math.pi);
      final pos = Offset(startX + drift, startY + travel);

      final particlePaint = paint..color = color.withValues(alpha: opacity.clamp(0.0, 1.0)); 
      final radius = 2.5 + random.nextDouble() * 2.5;

      switch (shape) {
        case ParticleShape.circle:
          canvas.drawCircle(pos, radius, particlePaint);
          break;
        case ParticleShape.spark:
          canvas.drawCircle(pos, radius * 0.8, particlePaint);
          break;
        case ParticleShape.teardrop:
          canvas.drawOval(Rect.fromCenter(center: pos, width: radius, height: radius * 2.2), particlePaint);
          break;
        case ParticleShape.puff:
          canvas.drawCircle(pos, radius * (1 + localT), particlePaint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => oldDelegate.progress != progress;
}
