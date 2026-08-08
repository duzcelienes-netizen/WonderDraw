/// Geçici adı "Lumi" olan gelecekteki maskot karakter için mimari iskelet.
/// M2'de UI'a EKLENMİYOR — sadece ileride bir `LumiOverlay` widget'ının
/// üzerine oturacağı veri şekli burada tanımlanıyor.
///
/// Lumi'nin PRD'deki tanımı: uzun yazılar yazmaz, sadece küçük mimikler yapar.
/// Bu yüzden model kasıtlı olarak "duygu durumu" + kısa bir tetikleyici olay
/// taşıyor, serbest metin taşımıyor.
enum LumiMood { idle, curious, cheering, sleepy }

class LumiState {
  const LumiState({this.mood = LumiMood.idle});

  final LumiMood mood;

  LumiState copyWith({LumiMood? mood}) => LumiState(mood: mood ?? this.mood);
}

/// İleride WonderObjectBehavior.personality okunarak Lumi'nin tepkisini
/// (örn. "playful" bir nesneye dokunulunca Lumi "cheering" olsun) belirleyecek
/// eşleme burada yaşayacak. Şimdilik boş — sadece yer tutucu.
class LumiReactionMapper {
  const LumiReactionMapper();

  LumiMood moodFor(LumiMood current) => current; // TODO: gerçek eşleme, Lumi UI'a eklendiğinde
}
