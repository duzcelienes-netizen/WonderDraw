import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../audio/sound_cue.dart';
import '../audio/sound_service.dart';
import '../constants/wonder_constants.dart';
import '../models/wonder_object_behavior.dart';

/// WonderDraw'ın "büyü" hissini tek merkezden yöneten kontrolcü.
/// ✨ parçacık, 💡 glow, 📳 haptic, 🎵 ses — hepsi buradan geçer.
/// İleride kamera sarsıntısı, ekran parlaması gibi yeni efektler eklemek
/// istendiğinde tek yapılacak iş bu sınıfa yeni bir metot eklemek olacak;
/// çağıran ekranların (MagicMomentScreen, AnimatedWonderObject) değişmesi
/// gerekmeyecek.
class MagicController {
  MagicController({
    required TickerProvider vsync,
    this.soundService = const SilentSoundService(),
  }) : anticipationController = AnimationController(
          vsync: vsync,
          duration: WonderConstants.magicAnticipationDuration,
        );

  /// Büyü anındaki bekleme/parıltı animasyonunu süren controller.
  /// UI bunu dinleyerek (AnimatedBuilder) parıltı/nefes efektini çizer;
  /// beat'lerin (haptic/ses) ZAMANLAMASINI bu sınıf yönetir.
  final AnimationController anticipationController;
  final SoundService soundService;

  /// PRD'deki sabit sıra: hafif titreşim → (ses) → bekleme → orta titreşim → (ses) → reveal.
  Future<void> playRevealSequence({MagicAnimationSpec spec = const MagicAnimationSpec()}) async {
    HapticFeedback.lightImpact();
    soundService.play(SoundCue.magicAnticipation);

    await anticipationController.forward(from: 0);

    HapticFeedback.mediumImpact();
    soundService.play(spec.revealSound);
  }

  /// Bir dokunma tepkisi başladığında çağrılır — hafif haptic + o tepkinin sesi.
  void playTapEffect(SoundCue cue) {
    HapticFeedback.selectionClick();
    soundService.play(cue);
  }

  void dispose() {
    anticipationController.dispose();
  }
}
