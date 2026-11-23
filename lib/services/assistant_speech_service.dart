import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Lecture à voix haute des réponses de Sika (synthèse vocale du téléphone).
///
/// Une seule instance pour l'app : une seule voix à la fois. Lire une autre
/// réponse coupe la précédente.
class AssistantSpeechService {
  static final AssistantSpeechService _instance = AssistantSpeechService._internal();
  factory AssistantSpeechService() => _instance;
  AssistantSpeechService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool _available = true;

  /// Appelé quand la lecture se termine (fin naturelle, arrêt ou erreur).
  VoidCallback? _onDone;

  bool get isAvailable => _available;

  Future<void> _ensureReady() async {
    if (_ready) return;
    try {
      // La lecture se termine avant que `speak` ne rende la main sur certains
      // moteurs : on attend explicitement la fin pour pouvoir changer le bouton.
      await _tts.awaitSpeakCompletion(false);
      final languages = await _tts.getLanguages as List<dynamic>?;
      final hasFrench = languages?.any((l) => l.toString().toLowerCase().startsWith('fr')) ?? true;
      if (!hasFrench) {
        _available = false;
        return;
      }
      await _tts.setLanguage('fr-FR');
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      _tts.setCompletionHandler(() => _finish());
      _tts.setCancelHandler(() => _finish());
      _tts.setErrorHandler((_) => _finish());
      _ready = true;
    } catch (e) {
      debugPrint('AssistantSpeechService: init impossible ($e)');
      _available = false;
    }
  }

  void _finish() {
    final callback = _onDone;
    _onDone = null;
    callback?.call();
  }

  /// Lit [text]. [onDone] est appelé à la fin de la lecture, quelle qu'en soit
  /// la raison. Renvoie false si la synthèse vocale n'est pas utilisable.
  Future<bool> speak(String text, {required VoidCallback onDone}) async {
    await _ensureReady();
    if (!_available) return false;

    // Coupe la lecture précédente sans déclencher son « terminé » deux fois.
    await stop();
    _onDone = onDone;
    final result = await _tts.speak(toSpokenText(text));
    if (result != 1) {
      _finish();
      return false;
    }
    return true;
  }

  Future<void> stop() async {
    if (!_ready) return;
    try {
      await _tts.stop();
    } catch (_) {}
    _finish();
  }

  /// Texte tel qu'il doit être prononcé : sans la mise en forme (gras, tirets)
  /// et avec la devise dite en toutes lettres.
  @visibleForTesting
  static String toSpokenText(String text) {
    return text
        .replaceAll('**', '')
        .replaceAll(RegExp(r'^\s*[-*•]\s+', multiLine: true), '')
        .replaceAllMapped(RegExp(r'\b(XOF|FCFA|F ?CFA)\b'), (_) => 'francs CFA')
        .replaceAll(RegExp(r'\n{2,}'), '. ')
        .replaceAll('\n', '. ')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }
}
