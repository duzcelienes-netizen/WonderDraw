import 'package:flutter/foundation.dart';
import '../audio/sound_cue.dart';
import 'ambient_effect.dart';
import 'personality.dart';
import 'reaction.dart';

/// Idle sırasında sürekli dönen hareketin tanımı. Mevcut per-type switch
/// mantığının (M1) yerini alıyor — artık bir "case" değil, bir veri kaydı.
@immutable
class IdleAnimationSpec {
  const IdleAnimationSpec({
    required this.duration,
    required this.reverses,
    this.motion = ReactionKind.happySway,
    this.sound = SoundCue.none,
  });

  final Duration duration;
  final bool reverses;

  /// Idle sırasında sürekli tekrar eden hareketin "şekli". Tap reaction'larla
  /// AYNI transform fonksiyonlarını (bkz. lib/animation/motion_curves.dart)
  /// kullanır — idle için ayrı bir hareket dili icat etmiyoruz, tek bir
  /// hareket kütüphanesi hem sürekli hem tek-seferlik oynatım için çalışıyor.
  final ReactionKind motion;

  final SoundCue sound;
}

/// Büyü anında (canlanma öncesi/esnası) nesneye özel ince ayar —
/// örn. güneş daha parlak bir glow ister, balık daha yumuşak bir reveal ister.
@immutable
class MagicAnimationSpec {
  const MagicAnimationSpec({
    this.glowIntensity = 0.0,
    this.revealSound = SoundCue.magicReveal,
  });

  final double glowIntensity; // 0.0 = glow yok
  final SoundCue revealSound;
}

/// Bir nesnenin tam "karakteri". WonderObjectRegistry bu sınıfın örneklerini
/// tutar. Yeni nesne eklemek = bu sınıftan yeni bir örnek oluşturup registry'ye
/// eklemek — hiçbir widget kodunun değişmesi gerekmez.
@immutable
class WonderObjectBehavior {
  const WonderObjectBehavior({
    required this.idleAnimation,
    required this.touchReactions,
    this.magicAnimation = const MagicAnimationSpec(),
    this.ambientEffects = const [],
    this.personality = WonderPersonality.neutral,
  }) : assert(touchReactions.length >= 3,
            'PRD kuralı: her nesne için en az 3 farklı tepki tanımlanmalı.');

  final IdleAnimationSpec idleAnimation;
  final List<ReactionSpec> touchReactions;
  final MagicAnimationSpec magicAnimation;

  /// M3 zemini — şimdilik hiçbir zamanlayıcı bunu okumuyor.
  final List<AmbientEffectSpec> ambientEffects;

  final WonderPersonality personality;

  /// soundProfile: idle + magic + her reaction'ın sesi zaten kendi spec'inde
  /// taşınıyor (tek bir yerde tekrar tanımlamamak için ayrı bir alan açmadık —
  /// "kod tekrarından kaçının" ilkesine göre ses her zaman ait olduğu
  /// animasyon spec'inin üzerinde durur). Bu getter, hepsini tek bakışta
  /// görmek isteyenler için bir kolaylık.
  List<SoundCue> get soundProfile => [
        idleAnimation.sound,
        magicAnimation.revealSound,
        ...touchReactions.map((r) => r.sound),
      ];
}
