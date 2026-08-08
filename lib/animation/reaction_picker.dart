import 'dart:math';
import '../constants/wonder_constants.dart';
import '../models/reaction.dart';

/// Bir nesnenin tepki listesinden "kontrollü rastgele" seçim yapar.
/// Son seçilen tepki(ler) tekrar seçilmez — böylece çocuk aynı tepkiyi
/// art arda görmez, ama tam bir döngü de değildir (öngörülemezlik korunur).
class ReactionPicker {
  ReactionPicker(this.reactions) : assert(reactions.isNotEmpty);

  final List<ReactionSpec> reactions;
  final Random _random = Random();
  final List<int> _recentIndices = [];

  ReactionSpec next() {
    if (reactions.length <= WonderConstants.reactionNoRepeatWindow) {
      // Çok az seçenek varsa tekrar önleme mantığı anlamsızlaşır — düz rastgele seç.
      return reactions[_random.nextInt(reactions.length)];
    }

    int index;
    do {
      index = _random.nextInt(reactions.length);
    } while (_recentIndices.contains(index));

    _recentIndices.add(index);
    if (_recentIndices.length > WonderConstants.reactionNoRepeatWindow) {
      _recentIndices.removeAt(0);
    }
    return reactions[index];
  }
}
