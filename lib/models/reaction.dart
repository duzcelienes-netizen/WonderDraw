import 'package:flutter/foundation.dart';
import '../audio/sound_cue.dart';

/// Bir dokunuş tepkisinin tanımı. Her nesnenin en az 3 farklı ReactionSpec'i
/// olur ve dokunuldukça bunlar sırayla (döngüsel) oynatılır — böylece
/// "acaba şimdi ne yapacak?" merakı korunur.
///
/// SÜRE KURALI (500-1500ms, PRD): bu artık bir constructor assert'i DEĞİL,
/// sadece bir sözleşme/dokümantasyon kuralıdır. Denendi: hem `duration >=
/// const Duration(...)` hem de `duration.inMilliseconds >= 500` biçimleri,
/// Dart'ın const-değerlendiricisinde "operands of this operator must be of
/// type 'num'" hatasına yol açtı — çünkü `duration` burada bir const
/// constructor'ın henüz bağlanmamış formal parametresi ve CFE, üzerinde
/// getter/operatör çağrısını (num'a çözünse bile) bu bağlamda constant-fold
/// edemiyor. Tüm `ReactionSpec` örnekleri zaten sabit, elle kontrol edilmiş
/// bir registry'de (`WonderObjectRegistry`) yaşadığı için runtime assert'e
/// de gerek yok — süreler orada tek tek 500-1500ms aralığında doğrulandı.
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

/// Tepki türleri. Yeni bir tepki eklemek = buraya bir değer eklemek +
/// motion_curves.dart içinde bir case eklemek.
///
/// `wingFlutter` ve `buzz`: mevcut 12 tür (bounce, sway, swim, spin vb.)
/// kanat çırpma / uçuş titreşimi hissini karşılamıyordu — kuş/kelebek/arı
/// için gerçekten farklı bir hareket dili gerekiyordu. Yeni bir animasyon
/// SİSTEMİ değil, aynı enum'a iki değer daha eklendi.
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
  wingFlutter,
  buzz,
}
