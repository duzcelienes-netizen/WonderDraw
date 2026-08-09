import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/reaction.dart';
import '../theme/app_theme.dart';
import '../widgets/particle_overlay.dart';

@immutable
class MotionFrame {
  const MotionFrame({
    this.offset = Offset.zero,
    this.rotation = 0,
    this.scale = 1,
    this.scaleX,
    this.scaleY,
    this.particle,
  });

  final Offset offset;
  final double rotation;
  final double scale;
  final double? scaleX;
  final double? scaleY;
  final ParticleFrameSpec? particle;

  double get effectiveScaleX => scaleX ?? scale;
  double get effectiveScaleY => scaleY ?? scale;
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

Curve easingFor(ReactionKind kind) {
  switch (kind) {
    case ReactionKind.bounce:
    case ReactionKind.houseBounceWithSmoke:
    case ReactionKind.sparkleBurst:
    case ReactionKind.bloom:
      return Curves.easeOutCubic;

    case ReactionKind.swimAway:
      return Curves.easeOutQuart;

    case ReactionKind.swimBack:
      return Curves.easeOutBack;

    case ReactionKind.spin:
    case ReactionKind.carWiggleWithWheels:
      return Curves.easeInOutCubic;

    case ReactionKind.wingFlutter:
    case ReactionKind.buzz:
      return Curves.easeInOutSine;

    default:
      return Curves.easeInOutSine;
  }
}

MotionFrame motionFrameFor(ReactionKind kind, double t) {
  switch (kind) {
    case ReactionKind.bounce:
      final h = math.sin(math.pi * t);
      return MotionFrame(
        offset: Offset(0, -14 * h),
        scaleY: 1.0 + 0.10 * h,
        scaleX: 1.0 - 0.06 * h,
      );

    case ReactionKind.glowPulse:
      return MotionFrame(
        scale: 1.0 + 0.07 * math.sin(math.pi * t),
      );

    case ReactionKind.spin:
      return MotionFrame(
        rotation: 2 * math.pi * t,
      );

    case ReactionKind.happySway:
      return MotionFrame(
        offset: Offset(
          math.sin(t * 2 * math.pi) * 4,
          0,
        ),
        rotation: math.sin(t * 2 * math.pi) * 0.06,
      );

    case ReactionKind.swayWithLeaves:
      return MotionFrame(
        offset: Offset(
          math.sin(t * 2 * math.pi) * 5,
          0,
        ),
        rotation: math.sin(t * 2 * math.pi) * 0.09,
        particle: const ParticleFrameSpec(
          shape: ParticleShape.teardrop,
          color: WonderColors.leafGreen,
        ),
      );

    case ReactionKind.swimAway:
      final dart = math.sin(math.pi * t);
      return MotionFrame(
        offset: Offset(
          -50 * dart,
          -8 * math.sin(2 * math.pi * t),
        ),
        rotation: -0.14 * dart,
        scaleX: 1.0 + 0.05 * dart,
        scaleY: 1.0 - 0.03 * dart,
      );

    case ReactionKind.swimBack:
      final flinch = math.sin(math.pi * t);
      return MotionFrame(
        offset: Offset(
          -22 * flinch,
          -4 * math.sin(2 * math.pi * t),
        ),
        rotation: -0.08 * flinch,
      );

    case ReactionKind.swimHappy:
      return MotionFrame(
        offset: Offset(
          math.sin(t * 2 * math.pi) * 26,
          math.sin(t * 4 * math.pi) * 6,
        ),
        rotation: math.sin(t * 2 * math.pi) * 0.08,
        scale: 1.0 + 0.04 * math.sin(t * 4 * math.pi),
      );

    case ReactionKind.rainDrops:
      return MotionFrame(
        offset: Offset(
          0,
          math.sin(t * 2 * math.pi) * 2,
        ),
        particle: const ParticleFrameSpec(
          shape: ParticleShape.teardrop,
          color: WonderColors.skyBlue,
          count: 12,
        ),
      );

    case ReactionKind.sparkleBurst:
      return MotionFrame(
        scale: 1.0 + 0.12 * math.sin(math.pi * t),
        rotation: 0.06 * math.sin(math.pi * t),
        particle: const ParticleFrameSpec(
          shape: ParticleShape.spark,
          color: WonderColors.sunYellow,
          fallsDown: false,
          count: 14,
        ),
      );

    case ReactionKind.houseBounceWithSmoke:
      final h = math.sin(math.pi * t);
      return MotionFrame(
        offset: Offset(0, -8 * h),
        scaleY: 1.0 + 0.06 * h,
        scaleX: 1.0 - 0.04 * h,
        particle: const ParticleFrameSpec(
          shape: ParticleShape.puff,
          color: Color(0xFFD8D8D8),
          fallsDown: false,
          count: 6,
        ),
      );

    case ReactionKind.carWiggleWithWheels:
      return MotionFrame(
        offset: Offset(
          math.sin(t * 4 * math.pi) * 6,
          0,
        ),
        rotation: math.sin(t * 4 * math.pi) * 0.025,
        scaleY: 1.0 +
            0.015 *
                math.sin(t * 8 * math.pi) *
                math.sin(math.pi * t),
      );

    case ReactionKind.bloom:
      final b = math.sin(math.pi * t);
      return MotionFrame(
        scale: 1.0 + 0.16 * b,
        rotation: b * 0.03,
      );

    case ReactionKind.genericNod:
      return MotionFrame(
        offset: Offset(
          0,
          -4 * math.sin(math.pi * t),
        ),
        rotation: math.sin(t * math.pi) * 0.04,
      );

    case ReactionKind.wingFlutter:
      final envelope = math.sin(math.pi * t);
      final flutter = math.sin(t * 10 * math.pi);

      return MotionFrame(
        offset: Offset(
          6 * envelope,
          -10 * envelope - 3 * flutter * envelope,
        ),
        rotation: 0.05 * flutter * envelope,
        scaleY: 1.0 - 0.05 * flutter.abs() * envelope,
      );

    case ReactionKind.buzz:
      final envelope = math.sin(math.pi * t);

      return MotionFrame(
        offset: Offset(
          2.2 * math.sin(t * 14 * math.pi) * envelope,
          1.6 * math.cos(t * 14 * math.pi) * envelope,
        ),
        rotation:
            0.035 * math.sin(t * 14 * math.pi) * envelope,
      );
  }
}
