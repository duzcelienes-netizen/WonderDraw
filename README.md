# WonderDraw — Milestone 2: "WONDER IS ALIVE"

## Bu milestone'da eklenenler

- **Dokunma tepkileri**: 8 çekirdek nesnenin (güneş, ağaç, bulut, ev, balık,
  araba, yıldız, çiçek) her biri en az 3 farklı tepkiye sahip; dokunuldukça
  kontrollü rastgele sırayla oynatılır (`ReactionPicker`), art arda aynısı
  tekrar etmez.
- **Animation Queue**: Hızlı ardışık dokunuşlar `ReactionQueue` ile sıraya
  alınır — animasyonlar asla birbirine girmez.
- **MagicController**: Büyü anındaki tüm efektler (parıltı, haptic, ses)
  artık tek merkezden yönetiliyor.
- **Parçacık efektleri**: yaprak dökülmesi, yağmur, duman, parıltı tozu —
  tek bir `ParticleOverlay` widget'ı üzerinden, tekrar kullanılabilir.
- **WonderConstants**: tüm ayarlanabilir sayılar tek dosyada.
- **Genişletilmiş WonderObjectBehavior**: artık `idleAnimation`,
  `touchReactions`, `magicAnimation`, `ambientEffects`, `personality` taşıyor.
- **Tek hareket kütüphanesi** (`motion_curves.dart`): idle döngü de, tap
  reaction da aynı `motionFrameFor()` fonksiyonundan geçiyor.
- **Mimari zemin (henüz UI'da yok)**: `mascot.dart` (Lumi), `saved_creation.dart`
  (ileride galeri için saklama modeli), `ambient_effect.dart` (M3 Emotion
  Engine zemini).

## Değişmeyen ilke

Çizim verisi (`DrawingStroke` noktaları) M1'den beri hiçbir zaman yeniden
üretilmiyor. M2'deki her yeni katman (reaction'lar, parçacıklar, glow) bu
noktaların ÜZERİNE bir `Transform`/overlay ekliyor, kendisi asla değiştirmiyor.

## Nasıl çalıştırılır

```bash
flutter pub get
flutter run
```

Bu ortamda Flutter SDK olmadığı için derleme/test edilemedi — kendi
makinenizde çalıştırıp bir sorunla karşılaşırsanız paylaşın, birlikte çözelim.

## Sıradaki adım

Milestone 3: kalan nesnelerin (ev/araba dışındakiler) özel karakterleri +
Emotion Engine (dokunulmadan da arada kendi kendine hareket etme, `ambientEffects`
alanı zaten hazır).

---

## APK Nasıl Üretilir (Flutter SDK'nız yoksa)

**Önemli tespit**: Bu proje şu ana kadar yalnızca `lib/` (Dart kaynak kodu) ve
`pubspec.yaml` olarak geliştirildi — `android/` klasörü (Gradle yapılandırması,
AndroidManifest.xml, vb.) hiç üretilmedi. APK almak için önce bu platform
iskeletinin oluşturulması gerekiyor; bu normalde `flutter create` komutuyla
saniyeler içinde, mevcut koda dokunmadan yapılır.

Sizin de belirttiğiniz gibi bilgisayarınızda Flutter SDK kurulu değil — bu
yüzden en pratik yol, kurulum yapmadan **GitHub Actions üzerinde bulutta**
APK üretmek. Proje artık buna hazır (`.github/workflows/build_apk.yml` eklendi).

### Yöntem A — GitHub Actions (kurulum gerektirmez, önerilen)

1. github.com'da yeni, boş bir repo oluşturun (public veya private, fark etmez).
2. Bu klasörün TAMAMINI o repoya push edin:
   ```bash
   cd wonderdraw
   git init
   git add .
   git commit -m "WonderDraw Milestone 2"
   git branch -M main
   git remote add origin <repo-url>
   git push -u origin main
   ```
3. GitHub'da repo sayfasında **Actions** sekmesine gidin — "Build WonderDraw
   Debug APK" iş akışı otomatik başlayacak (push sonrası).
4. İş akışı bitince (birkaç dakika sürer) **Actions → ilgili çalıştırma →
   Artifacts** bölümünden `wonderdraw-debug-apk` dosyasını indirin — içinde
   `app-debug.apk` olacak.

### Yöntem B — Kendi bilgisayarınıza Flutter kurup yerel derleme

1. Flutter'ı kurun: https://docs.flutter.dev/get-started/install
2. Android Studio'yu kurun (Android SDK için gerekli).
3. Terminalde:
   ```bash
   cd wonderdraw
   flutter create --platforms=android .
   flutter pub get
   flutter build apk --debug
   ```
4. APK şurada oluşur: `build/app/outputs/flutter-apk/app-debug.apk`

## APK'yı Android Telefona Kurma

1. `app-debug.apk` dosyasını telefonunuza aktarın (WhatsApp'a kendinize
   gönderme, Google Drive, USB kablo, veya e-posta — hangisi kolayınıza
   geliyorsa).
2. Telefonda dosyaya dokunduğunuzda "Bilinmeyen kaynaklardan yükleme"
   uyarısı çıkabilir — **Ayarlar → Güvenlik** (veya kurulum sırasında çıkan
   uyarıdaki "İzin ver" butonu) üzerinden o anlık izin verin.
3. Kurulum tamamlandığında WonderDraw uygulama listenizde görünecek.

Not: Bu bir **debug APK**'dır — geliştirme/test amaçlıdır, imzasız ve
büyük boyutludur. Play Store'a yüklenecek son sürüm için M5'te "release"
imzalı bir APK/AAB üretimi ayrıca ele alınacak.
