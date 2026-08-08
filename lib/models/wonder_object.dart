import 'package:flutter/material.dart';
import 'wonder_object_registry.dart';

/// "Bu ne olabilir?" ekranında sunulan nesne türleri.
/// PRD'deki ~20 nesnenin tamamı burada tanımlı. Bir nesnenin özel bir
/// karakteri (kaliteli animasyon seti) olup olmadığı artık burada değil,
/// tek doğruluk kaynağı olan WonderObjectRegistry'de tutulur — bkz.
/// `WonderObject.isAnimated` getter'ı.
enum WonderObjectType {
  sun,
  tree,
  fish,
  house,
  cloud,
  star,
  moon,
  flower,
  bird,
  car,
  apple,
  butterfly,
  bee,
  ladybug,
  unicorn,
  rainbow,
  rocket,
  balloon,
  heart,
  mushroom,
}

class WonderObject {
  const WonderObject({
    required this.type,
    required this.emoji,
    required this.label,
  });

  final WonderObjectType type;
  final String emoji;
  final String label;

  /// Registry'de özel bir karakter (kaliteli animasyon seti) tanımlıysa true.
  /// Tanımlı değilse jenerik ama hâlâ sıcak bir tepki alır — asla soğuk bir
  /// "desteklenmiyor" mesajı gösterilmez.
  bool get isAnimated => WonderObjectRegistry.hasQualityBehavior(type);
}

/// Nesne kataloğu. Yeni nesne eklemek = tek satır eklemek (PRD'nin istediği gibi
/// "yeni nesne eklemek kolay olmalı" ilkesine uygun).
const List<WonderObject> wonderObjectCatalog = [
  WonderObject(type: WonderObjectType.sun, emoji: '☀️', label: 'Güneş'),
  WonderObject(type: WonderObjectType.tree, emoji: '🌳', label: 'Ağaç'),
  WonderObject(type: WonderObjectType.fish, emoji: '🐟', label: 'Balık'),
  WonderObject(type: WonderObjectType.house, emoji: '🏠', label: 'Ev'),
  WonderObject(type: WonderObjectType.cloud, emoji: '☁️', label: 'Bulut'),
  WonderObject(type: WonderObjectType.star, emoji: '⭐', label: 'Yıldız'),
  WonderObject(type: WonderObjectType.moon, emoji: '🌙', label: 'Ay'),
  WonderObject(type: WonderObjectType.flower, emoji: '🌸', label: 'Çiçek'),
  WonderObject(type: WonderObjectType.bird, emoji: '🐦', label: 'Kuş'),
  WonderObject(type: WonderObjectType.car, emoji: '🚗', label: 'Araba'),
  WonderObject(type: WonderObjectType.apple, emoji: '🍎', label: 'Elma'),
  WonderObject(type: WonderObjectType.butterfly, emoji: '🦋', label: 'Kelebek'),
  WonderObject(type: WonderObjectType.bee, emoji: '🐝', label: 'Arı'),
  WonderObject(type: WonderObjectType.ladybug, emoji: '🐞', label: 'Uğur Böceği'),
  WonderObject(type: WonderObjectType.unicorn, emoji: '🦄', label: 'Unicorn'),
  WonderObject(type: WonderObjectType.rainbow, emoji: '🌈', label: 'Gökkuşağı'),
  WonderObject(type: WonderObjectType.rocket, emoji: '🚀', label: 'Roket'),
  WonderObject(type: WonderObjectType.balloon, emoji: '🎈', label: 'Balon'),
  WonderObject(type: WonderObjectType.heart, emoji: '❤️', label: 'Kalp'),
  WonderObject(type: WonderObjectType.mushroom, emoji: '🍄', label: 'Mantar'),
];

/// Özel karakteri tanımlı (kaliteli animasyonlu) nesneler.
List<WonderObject> get featuredWonderObjects =>
    wonderObjectCatalog.where((o) => o.isAnimated).toList();
