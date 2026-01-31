import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final _player = AudioPlayer();

  static Future<void> _playSound(String soundPath) async {
    try {
      await _player.play(AssetSource(soundPath));
    } catch (e) {
      // Fallback vers son système si fichier introuvable
      SystemSound.play(SystemSoundType.click);
    }
  }

  static Future<void> playBeep() async {
    if (Platform.isIOS) {
      await _playSound('sounds/bip.wav');
    } else {
      SystemSound.play(SystemSoundType.click);
    }
    HapticFeedback.lightImpact();
  }

  static Future<void> playError() async {
    if (Platform.isIOS) {
      await _playSound('sounds/error.wav');
    } else {
      SystemSound.play(SystemSoundType.alert);
    }
    HapticFeedback.heavyImpact();
  }
}
