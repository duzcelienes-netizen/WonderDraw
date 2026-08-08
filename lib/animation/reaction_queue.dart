import 'dart:async';
import '../constants/wonder_constants.dart';
import '../models/reaction.dart';

/// Ardışık hızlı dokunuşların animasyonları birbirine girmesini önler.
/// Yeni bir tepki, bir öncekinin bitişini (+ küçük bir cooldown'u) bekleyip
/// sırayla oynatılır. Kuyruk gereksiz yere şişmesin diye 2'den fazla
/// bekleyen tepki varsa en eskisi atılır — çocuk 10 kez art arda dokunursa
/// uygulama "tepki borcu" biriktirmez, her zaman güncel kalır.
class ReactionQueue {
  ReactionQueue({required this.onPlay});

  /// Bir tepkiyi fiilen oynatan callback; süresi kadar süren bir Future döner.
  final Future<void> Function(ReactionSpec reaction) onPlay;

  final List<ReactionSpec> _pending = [];
  bool _isPlaying = false;

  static const int _maxQueueLength = 2;

  void enqueue(ReactionSpec reaction) {
    if (_pending.length >= _maxQueueLength) {
      _pending.removeAt(0); // en eski bekleyeni at, akışı güncel tut
    }
    _pending.add(reaction);
    _drain();
  }

  Future<void> _drain() async {
    if (_isPlaying) return;
    _isPlaying = true;
    while (_pending.isNotEmpty) {
      final reaction = _pending.removeAt(0);
      await onPlay(reaction);
      await Future.delayed(WonderConstants.reactionCooldown);
    }
    _isPlaying = false;
  }

  void dispose() {
    _pending.clear();
  }
}
