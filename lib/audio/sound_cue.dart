/// Oynatılabilecek kısa ses ipuçları. M2'de sadece mimari — gerçek ses
/// dosyaları ve çalma mantığı M4'te bağlanacak.
enum SoundCue {
  none,
  magicAnticipation, // büyü anı beklerken
  magicReveal, // canlanma anı
  sunDing,
  leafRustle,
  waterSplash,
  sparkle,
  rainPatter,
  smokePuff,
  carHonkSoft,
  bloomChime,
  genericPop,
}
