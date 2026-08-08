import 'package:flutter/foundation.dart';
import '../audio/sound_cue.dart';

/// Bir dokunuş tepkisinin tanımı.
@immutable
class ReactionSpec {
  const ReactionSpec({
    required this.kind,
    required this.duration,
    this.sound = SoundCue.none,
  });

  final ReactionKind kind;
  final Duration duration;
  final SoundCue sound;
}

/// Tepki türleri.
enum ReactionKind {
  bounce,
  glowPulse,
  spin,
  happySway,
  swayWithLeaves,
  swimAway,
  swimBack,
  swimHappy,
  rainDrops,
  sparkleBurst,
  houseBounceWithSmoke,
  carWiggleWithWheels,
  bloom,
  genericNod,
}
