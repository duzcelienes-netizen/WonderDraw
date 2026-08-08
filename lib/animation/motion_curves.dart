import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/reaction.dart';
import '../theme/app_theme.dart';
import '../widgets/particle_overlay.dart';

/// Bir anlık hareket durumu: ne kadar taşınacak, ne kadar dönecek, ne kadar
/// ölçeklenecek, ve varsa hangi parçacık efekti eşlik edecek.
@immutable
class MotionFrame {
  const MotionFrame({
    this.offset = Offset.zero,
    this.rotation = 0,
    this.scale = 1,
    this.particle,
  });

  final Offset offset;
  final double rotation;
  final double scale;
  final ParticleFrameSpec? particle;
}

@immutable
class ParticleFrameSpec {
  const ParticleFrameSpec({
    required this.shape,
    required this.color,
    this.fallsDown = true,
    this.count = 8,
  });

  final ParticleShape shape;
  final Color color;
  final bool fallsDown;
  final int count;
}

/// TEK hareket kütüphanesi. Idle döngüsü de, tek seferlik dokunma tepkileri
/// de bu fonksiyondan geçer — "bounce nasıl görünür" sorusunun cevabı
/// sistemde tam olarak bir yerde yaşar.
///
/// [t] her zaman 0.0 → 1.0 arasında normalize edilmiş ilerlemedir. Idle
/// döngüsünde bu değer AnimationController tarafından sürekli 0↔1 arasında
/// gidip geliyor olabilir (reverses: true) ya da sürekli 0→1 sarıp
/// başa dönüyor olabilir (reverses: false, örn. güneşin dönüşü).
MotionFrame motionFrameFor(ReactionKind kind, double t) {
  switch (kind) {
    case ReactionKind.bounce:
      return MotionFrame(offset: Offset(0, -14 * math.sin(math.pi * t)));

    case ReactionKind.glowPulse:
      return MotionFrame(scale: 1.0 + 0.06 * math.sin(math.pi * t));

    case ReactionKind.spin:
      return MotionFrame(rotation: 2 * math.pi * t);

    case ReactionKind.happySway:
      return MotionFrame(
        offset: Offset(math.sin(t * 2 * math.pi) * 4, 0),
        rotation: math.sin(t * 2 * math.pi) * 0.06,
      );

    case ReactionKind.swayWithLeaves:
      return MotionFrame(
        offset: Offset(math.sin(t * 2 * math.pi) * 5, 0),
        rotation: math.sin(t * 2 * math.pi) * 0.08,
        particle: const ParticleFrameSpec(
          shape: ParticleShape.teardrop,
          color: WonderColors.leafGreen,
        ),
      );

    case ReactionKind.swimAway:
      return MotionFrame(
        offset: Offset(-40 * t, math.sin(t * math.pi) * -6),
        rotation: -0.1 * t,
      );

    case ReactionKind.swimBack:
      return MotionFrame(
        offset: Offset(-40 * (1 - t), math.sin(t * math.pi) * -6),
        rotation: 0.1 * (1 - t),
      );

    case ReactionKind.swimHappy:
      return MotionFrame(
        offset: Offset(math.sin(t * 2 * math.pi) * 26, math.sin(t * 4 * math.pi) * 6),
        rotation: math.sin(t * 2 * math.pi) * 0.08,
      );

    case ReactionKind.rainDrops:
      return MotionFrame(
        offset: Offset(0, math.sin(t * 2 * math.pi) * 2),
        particle: const ParticleFrameSpec(
          shape: ParticleShape.teardrop,
          color: WonderColors.skyBlue,
          count: 12,
        ),
      );

    case ReactionKind.sparkleBurst:
      return MotionFrame(
        scale: 1.0 + 0.1 * math.sin(math.pi * t),
        particle: const ParticleFrameSpec(
          shape: ParticleShape.spark,
          color: WonderColors.sunYellow,
          fallsDown: false,
          count: 14,
        ),
      );

    case ReactionKind.houseBounceWithSmoke:
      return MotionFrame(
        offset: Offset(0, -8 * math.sin(math.pi * t)),
        particle: const ParticleFrameSpec(
          shape: ParticleShape.puff,
          color: Color(0xFFD8D8D8),
          fallsDown: false,
          count: 6,
        ),
      );

    case ReactionKind.carWiggleWithWheels:
      return MotionFrame(
        offset: Offset(math.sin(t * 4 * math.pi) * 6, 0),
        rotation: math.sin(t * 4 * math.pi) * 0.02,
      );

    case ReactionKind.bloom:
      return MotionFrame(
        scale: 1.0 + 0.15 * math.sin(math.pi * t),
        rotation: math.sin(t * math.pi) * 0.03,
      );

    case ReactionKind.genericNod:
      return MotionFrame(
        offset: Offset(0, -4 * math.sin(math.pi * t)),
        rotation: math.sin(t * math.pi) * 0.04,
      );
  }
}
