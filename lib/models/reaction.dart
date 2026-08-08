import 'package:flutter/foundation.dart';
import '../audio/sound_cue.dart';

/// Bir dokunuş tepkisinin tanımı. Her nesnenin en az 3 farklı ReactionSpec'i
/// olur ve dokunuldukça bunlar sırayla (döngüsel) oynatılır — böylece
/// "acaba şimdi ne yapacak?" merakı korunur.
@immutable
class ReactionSpec {
  const ReactionSpec({
    required this.kind,
    required this.duration,
    this.sound = SoundCue.none,
  }) : assert(
            // Duration nesnelerini doğrudan >= / <= ile karşılaştırmak
            // const bağlamda GEÇERSİZ (Dart'ın const değerlendiricisi bu
            // operatörleri sadece num türü operandlarla kabul ediyor —
            // "operands of this operator must be of type 'num'" hatasının
            // kaynağı buydu). .inMilliseconds ile int (num) karşılaştırması
            // yaparak aynı kuralı const-güvenli şekilde ifade ediyoruz;
            // 500-1500ms sınırının kendisi hiç değişmedi.
            duration.inMilliseconds >= 500 && duration.inMilliseconds <= 1500,
            'Reaction süresi 500-1500ms aralığında olmalı (PRD kuralı).');

  final ReactionKind kind;
  final Duration duration;
  final SoundCue sound;
}

/// Tepki türleri. Yeni bir tepki eklemek = buraya bir değer eklemek +
/// _ReactionAnimator içinde bir case eklemek.
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
