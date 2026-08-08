/// WonderDraw'ın "oyun hissi"ni ayarlayan tüm sabit değerler.
/// Hiçbir animasyon/efekt kodu kendi büyülü sayısını taşımaz — hepsi buradan okur.
/// Bu, oyun hissini değiştirmeyi (örn. daha zıplak, daha yavaş, daha parlak)
/// tek dosyada yapılabilir hale getirir.
class WonderConstants {
  WonderConstants._();

  // --- Büyü Anı (Magic Moment) ---
  static const Duration magicAnticipationDuration = Duration(milliseconds: 1000);
  static const int magicParticleCount = 18;
  static const double magicGlowIntensity = 0.5;
  static const double breatheAmplitude = 0.03; // bekleme anındaki nefes alma ölçeği

  // --- Idle (kendiliğinden) hareket ---
  static const double idleAmplitude = 6.0; // piksel cinsinden hafif hareket genliği
  static const double idleRotationAmplitude = 0.04; // radyan

  // --- Dokunma tepkileri ---
  static const Duration reactionMinDuration = Duration(milliseconds: 500);
  static const Duration reactionMaxDuration = Duration(milliseconds: 1500);
  static const Duration reactionCooldown = Duration(milliseconds: 80); // ardışık dokunuşlar arası minimum boşluk
  static const double touchScale = 1.08; // dokunulduğunda hafif büyüme
  static const double jumpHeight = 14.0;

  // --- Randomizer ---
  static const int reactionNoRepeatWindow = 1; // son 1 tepki tekrar seçilmez

  // --- Ambient (M3 zemini) ---
  static const Duration ambientCheckInterval = Duration(seconds: 6);
  static const double ambientTriggerProbability = 0.25; // her kontrolde %25 ihtimalle küçük bir hareket
}
