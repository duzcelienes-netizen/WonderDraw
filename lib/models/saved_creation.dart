import '../models/drawing.dart';
import '../models/wonder_object.dart';

/// Çocuğun canlandırdığı bir çizimin saklanabilir hali.
/// Şu an hiçbir yerde kaydedilmiyor/okunmuyor — sadece ileride
/// (galeri ekranı, "seni bekliyordu" hissi) ihtiyaç duyulacak temiz
/// bir model olarak hazır bulunuyor.
class SavedCreation {
  SavedCreation({
    required this.id,
    required this.drawing,
    required this.objectType,
    required this.createdAt,
  });

  final String id;
  final Drawing drawing;
  final WonderObjectType objectType;
  final DateTime createdAt;
}

/// Saklama mekanizmasının soyutlaması. İleride bir `LocalCreationRepository`
/// (örn. dosya sistemi veya basit bir yerel veritabanı ile) bu arayüzü
/// implemente edecek; UI hiçbir zaman saklama detayına bağımlı olmayacak.
abstract class CreationRepository {
  Future<void> save(SavedCreation creation);
  Future<List<SavedCreation>> loadAll();
}

/// M2/M3 için varsayılan: hiçbir şeyi kalıcı olarak saklamaz, sadece
/// arayüzü karşılar. Gerçek implementasyon galeri ekranıyla birlikte gelecek.
class InMemoryCreationRepository implements CreationRepository {
  final List<SavedCreation> _items = [];

  @override
  Future<void> save(SavedCreation creation) async {
    _items.add(creation);
  }

  @override
  Future<List<SavedCreation>> loadAll() async => List.unmodifiable(_items);
}
