import 'package:flutter/foundation.dart';
import 'reaction.dart';

/// M3'te gelecek "Emotion Engine"in zemini: bir nesnenin dokunulmadan da
/// arada kendi kendine yapacağı küçük hareketin tanımı.
/// M2'de bu sınıf sadece VERİ olarak var — hiçbir zamanlayıcı bunu henüz
/// okumuyor/tetiklemiyor. M3'te tek yapılacak iş: `ambientEffects`i periyodik
/// okuyup `WonderConstants.ambientTriggerProbability` ile tetikleyen bir
/// zamanlayıcı eklemek; bu dosyanın veya davranış modelinin değişmesi gerekmez.
@immutable
class AmbientEffectSpec {
  const AmbientEffectSpec({required this.kind, required this.duration});

  final ReactionKind kind; // ambient hareketler de reaction'larla aynı görsel dile sahip
  final Duration duration;
}
