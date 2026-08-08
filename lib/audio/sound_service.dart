import 'sound_cue.dart';

/// Ses çalma soyutlaması. WonderDraw'ın geri kalanı hiçbir zaman `just_audio`
/// gibi bir pakete doğrudan bağımlı olmaz — sadece bu arayüzü çağırır.
/// M4'te gerçek ses dosyalarını çalan bir `AssetSoundService` eklenecek;
/// o zamana kadar `SilentSoundService` kullanılıyor, hiçbir çağrı yeri değişmeyecek.
abstract class SoundService {
  void play(SoundCue cue);
}

/// M2/M3 için varsayılan: hiçbir şey çalmaz ama her çağrıyı güvenle yutar.
/// PRD: "Sesler asla ön plana çıkmasın" — sessiz de olsa akış hiç bozulmaz.
class SilentSoundService implements SoundService {
  const SilentSoundService();

  @override
  void play(SoundCue cue) {
    // TODO(M4): gerçek ses dosyasını `cue`ya göre çal.
  }
}
