import '../audio/sound_cue.dart';
import 'ambient_effect.dart';
import 'personality.dart';
import 'reaction.dart';
import 'wonder_object.dart';
import 'wonder_object_behavior.dart';

/// WonderDraw'ın "karakter kataloğu". Yeni bir nesne eklemek için tek
/// yapılması gereken: bu Map'e yeni bir WonderObjectBehavior girdisi eklemek.
/// Hiçbir widget kodunun değişmesi gerekmez (bkz. animated_wonder_object.dart).
class WonderObjectRegistry {
  WonderObjectRegistry._();

  static final Map<WonderObjectType, WonderObjectBehavior> _behaviors = {
    WonderObjectType.sun: const WonderObjectBehavior(
      personality: WonderPersonality.playful,
      idleAnimation: IdleAnimationSpec(
        duration: Duration(seconds: 4),
        reverses: false,
        motion: ReactionKind.spin,
      ),
      magicAnimation: MagicAnimationSpec(glowIntensity: 1.0),
      touchReactions: [
        ReactionSpec(kind: ReactionKind.bounce, duration: Duration(milliseconds: 600), sound: SoundCue.sunDing),
        ReactionSpec(kind: ReactionKind.glowPulse, duration: Duration(milliseconds: 900), sound: SoundCue.sparkle),
        ReactionSpec(kind: ReactionKind.spin, duration: Duration(milliseconds: 800), sound: SoundCue.sunDing),
        ReactionSpec(kind: ReactionKind.happySway, duration: Duration(milliseconds: 1000), sound: SoundCue.genericPop),
      ],
      ambientEffects: [
        AmbientEffectSpec(kind: ReactionKind.glowPulse, duration: Duration(milliseconds: 900)),
      ],
    ),
    WonderObjectType.tree: const WonderObjectBehavior(
      personality: WonderPersonality.gentle,
      idleAnimation: IdleAnimationSpec(
        duration: Duration(seconds: 2),
        reverses: true,
        motion: ReactionKind.happySway,
      ),
      touchReactions: [
        ReactionSpec(kind: ReactionKind.swayWithLeaves, duration: Duration(milliseconds: 1400), sound: SoundCue.leafRustle),
        ReactionSpec(kind: ReactionKind.happySway, duration: Duration(milliseconds: 900), sound: SoundCue.leafRustle),
        ReactionSpec(kind: ReactionKind.bounce, duration: Duration(milliseconds: 700), sound: SoundCue.genericPop),
      ],
      ambientEffects: [
        AmbientEffectSpec(kind: ReactionKind.happySway, duration: Duration(milliseconds: 1200)),
      ],
    ),
    WonderObjectType.fish: const WonderObjectBehavior(
      personality: WonderPersonality.shy,
      idleAnimation: IdleAnimationSpec(
        duration: Duration(seconds: 3),
        reverses: true,
        motion: ReactionKind.swimHappy,
      ),
      touchReactions: [
        ReactionSpec(kind: ReactionKind.swimAway, duration: Duration(milliseconds: 700), sound: SoundCue.waterSplash),
        ReactionSpec(kind: ReactionKind.swimBack, duration: Duration(milliseconds: 700), sound: SoundCue.waterSplash),
        ReactionSpec(kind: ReactionKind.swimHappy, duration: Duration(milliseconds: 1000), sound: SoundCue.waterSplash),
      ],
      ambientEffects: [
        AmbientEffectSpec(kind: ReactionKind.swimHappy, duration: Duration(milliseconds: 1000)),
      ],
    ),
    WonderObjectType.cloud: const WonderObjectBehavior(
      personality: WonderPersonality.calm,
      idleAnimation: IdleAnimationSpec(
        duration: Duration(seconds: 6),
        reverses: true,
        motion: ReactionKind.happySway,
      ),
      touchReactions: [
        ReactionSpec(kind: ReactionKind.rainDrops, duration: Duration(milliseconds: 1200), sound: SoundCue.rainPatter),
        ReactionSpec(kind: ReactionKind.bounce, duration: Duration(milliseconds: 600), sound: SoundCue.genericPop),
        ReactionSpec(kind: ReactionKind.happySway, duration: Duration(milliseconds: 1000), sound: SoundCue.genericPop),
      ],
      ambientEffects: [
        AmbientEffectSpec(kind: ReactionKind.happySway, duration: Duration(milliseconds: 1500)),
      ],
    ),
    WonderObjectType.star: const WonderObjectBehavior(
      personality: WonderPersonality.curious,
      idleAnimation: IdleAnimationSpec(
        duration: Duration(milliseconds: 1500),
        reverses: true,
        motion: ReactionKind.glowPulse,
      ),
      magicAnimation: MagicAnimationSpec(glowIntensity: 0.8),
      touchReactions: [
        ReactionSpec(kind: ReactionKind.sparkleBurst, duration: Duration(milliseconds: 800), sound: SoundCue.sparkle),
        ReactionSpec(kind: ReactionKind.glowPulse, duration: Duration(milliseconds: 700), sound: SoundCue.sparkle),
        ReactionSpec(kind: ReactionKind.spin, duration: Duration(milliseconds: 600), sound: SoundCue.genericPop),
      ],
      ambientEffects: [
        AmbientEffectSpec(kind: ReactionKind.glowPulse, duration: Duration(milliseconds: 700)),
      ],
    ),
    WonderObjectType.house: const WonderObjectBehavior(
      personality: WonderPersonality.cozy,
      idleAnimation: IdleAnimationSpec(
        duration: Duration(seconds: 5),
        reverses: true,
        motion: ReactionKind.genericNod,
      ),
      touchReactions: [
        ReactionSpec(kind: ReactionKind.houseBounceWithSmoke, duration: Duration(milliseconds: 1200), sound: SoundCue.smokePuff),
        ReactionSpec(kind: ReactionKind.bounce, duration: Duration(milliseconds: 600), sound: SoundCue.genericPop),
        ReactionSpec(kind: ReactionKind.genericNod, duration: Duration(milliseconds: 700), sound: SoundCue.genericPop),
      ],
    ),
    WonderObjectType.car: const WonderObjectBehavior(
      personality: WonderPersonality.energetic,
      idleAnimation: IdleAnimationSpec(
        duration: Duration(seconds: 2),
        reverses: true,
        motion: ReactionKind.carWiggleWithWheels,
      ),
      touchReactions: [
        ReactionSpec(kind: ReactionKind.carWiggleWithWheels, duration: Duration(milliseconds: 900), sound: SoundCue.carHonkSoft),
        ReactionSpec(kind: ReactionKind.bounce, duration: Duration(milliseconds: 500), sound: SoundCue.genericPop),
        ReactionSpec(kind: ReactionKind.happySway, duration: Duration(milliseconds: 800), sound: SoundCue.genericPop),
      ],
    ),
    WonderObjectType.flower: const WonderObjectBehavior(
      personality: WonderPersonality.happy,
      idleAnimation: IdleAnimationSpec(
        duration: Duration(seconds: 3),
        reverses: true,
        motion: ReactionKind.happySway,
      ),
      touchReactions: [
        ReactionSpec(kind: ReactionKind.bloom, duration: Duration(milliseconds: 900), sound: SoundCue.bloomChime),
        ReactionSpec(kind: ReactionKind.happySway, duration: Duration(milliseconds: 700), sound: SoundCue.genericPop),
        ReactionSpec(kind: ReactionKind.glowPulse, duration: Duration(milliseconds: 600), sound: SoundCue.sparkle),
      ],
    ),
  };

  /// Henüz özel karakteri tanımlanmamış nesneler (M1'deki "yakında" davranışının
  /// M2 karşılığı) — soğuk bir "desteklenmiyor" mesajı yerine nazik, jenerik
  /// bir tepki verir.
  static const WonderObjectBehavior _generic = WonderObjectBehavior(
    personality: WonderPersonality.neutral,
    idleAnimation: IdleAnimationSpec(
      duration: Duration(seconds: 3),
      reverses: true,
      motion: ReactionKind.genericNod,
    ),
    touchReactions: [
      ReactionSpec(kind: ReactionKind.genericNod, duration: Duration(milliseconds: 700), sound: SoundCue.genericPop),
      ReactionSpec(kind: ReactionKind.bounce, duration: Duration(milliseconds: 600), sound: SoundCue.genericPop),
      ReactionSpec(kind: ReactionKind.happySway, duration: Duration(milliseconds: 800), sound: SoundCue.genericPop),
    ],
  );

  static WonderObjectBehavior behaviorFor(WonderObjectType type) {
    return _behaviors[type] ?? _generic;
  }

  static bool hasQualityBehavior(WonderObjectType type) => _behaviors.containsKey(type);
}
