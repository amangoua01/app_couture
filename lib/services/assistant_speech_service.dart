import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Une voix française installée sur le téléphone.
class AssistantVoice {
  final String name;
  final String locale;

  /// « very high », « high », « normal », « low », « very low » (Android).
  final String quality;

  /// Voix qui demande internet : en général la plus naturelle.
  final bool network;

  const AssistantVoice({
    required this.name,
    required this.locale,
    required this.quality,
    required this.network,
  });

  int get _qualityRank => switch (quality.toLowerCase()) {
        'very high' => 4,
        'high' => 3,
        'normal' => 2,
        'low' => 1,
        _ => 0,
      };

  /// Sert à choisir la meilleure voix par défaut : qualité d'abord, puis
  /// voix « réseau » (plus naturelles), puis le français de France.
  int get score => _qualityRank * 10 + (network ? 4 : 0) + (locale == 'fr-FR' ? 2 : 0);

  String get qualityLabel => switch (quality.toLowerCase()) {
        'very high' => 'qualité maximale',
        'high' => 'haute qualité',
        'normal' => 'qualité standard',
        _ => 'qualité basique',
      };
}

/// Lecture à voix haute des réponses de Sika (synthèse vocale du téléphone).
///
/// Une seule instance pour l'app : une seule voix à la fois. Lire une autre
/// réponse coupe la précédente. La voix, la vitesse et le ton se règlent et se
/// mémorisent ; par défaut on prend la meilleure voix française installée.
class AssistantSpeechService {
  static final AssistantSpeechService _instance = AssistantSpeechService._internal();
  factory AssistantSpeechService() => _instance;
  AssistantSpeechService._internal();

  static const _kName = 'assistant_voice_name';
  static const _kLocale = 'assistant_voice_locale';
  static const _kRate = 'assistant_voice_rate';
  static const _kPitch = 'assistant_voice_pitch';

  /// Vitesse (0,5 = normale sur Android) et ton (1 = naturel).
  static const double defaultRate = 0.5;
  static const double defaultPitch = 1.0;

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool _available = true;

  double rate = defaultRate;
  double pitch = defaultPitch;
  AssistantVoice? voice;
  List<AssistantVoice> _voices = const [];

  /// Appelé quand la lecture se termine (fin naturelle, arrêt ou erreur).
  VoidCallback? _onDone;

  bool get isAvailable => _available;

  Future<void> _ensureReady() async {
    if (_ready) return;
    try {
      await _tts.awaitSpeakCompletion(false);
      final languages = await _tts.getLanguages as List<dynamic>?;
      final hasFrench = languages?.any((l) => l.toString().toLowerCase().startsWith('fr')) ?? true;
      if (!hasFrench) {
        _available = false;
        return;
      }
      await _tts.setLanguage('fr-FR');

      _voices = await _loadFrenchVoices();
      final prefs = await SharedPreferences.getInstance();
      rate = prefs.getDouble(_kRate) ?? defaultRate;
      pitch = prefs.getDouble(_kPitch) ?? defaultPitch;
      final savedName = prefs.getString(_kName);
      final savedLocale = prefs.getString(_kLocale);
      voice = _voices.where((v) => v.name == savedName && v.locale == savedLocale).firstOrNull ??
          (_voices.isEmpty ? null : _voices.first); // classées : la meilleure d'abord

      await _apply();
      _tts.setCompletionHandler(() => _finish());
      _tts.setCancelHandler(() => _finish());
      _tts.setErrorHandler((_) => _finish());
      _ready = true;
    } catch (e) {
      debugPrint('AssistantSpeechService: init impossible ($e)');
      _available = false;
    }
  }

  Future<List<AssistantVoice>> _loadFrenchVoices() async {
    final raw = await _tts.getVoices as List<dynamic>?;
    final voices = <AssistantVoice>[];
    for (final item in raw ?? const []) {
      if (item is! Map) continue;
      final locale = (item['locale'] ?? '').toString();
      if (!locale.toLowerCase().startsWith('fr')) continue;
      voices.add(AssistantVoice(
        name: (item['name'] ?? '').toString(),
        locale: locale,
        quality: (item['quality'] ?? '').toString(),
        network: (item['network_required'] ?? '0').toString() == '1',
      ));
    }
    // Meilleure voix d'abord ; à égalité, ordre alphabétique pour rester stable.
    voices.sort((a, b) => b.score != a.score ? b.score.compareTo(a.score) : a.name.compareTo(b.name));
    if (kDebugMode) {
      for (final v in voices) {
        debugPrint('Voix française : ${v.name} [${v.locale}] qualité=${v.quality} réseau=${v.network} score=${v.score}');
      }
    }
    return voices;
  }

  Future<void> _apply() async {
    final v = voice;
    if (v != null) {
      await _tts.setVoice({'name': v.name, 'locale': v.locale});
    }
    await _tts.setSpeechRate(rate);
    await _tts.setPitch(pitch);
  }

  /// Voix françaises installées, la meilleure d'abord.
  Future<List<AssistantVoice>> frenchVoices() async {
    await _ensureReady();
    return _voices;
  }

  Future<void> selectVoice(AssistantVoice v) async {
    await _ensureReady();
    voice = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, v.name);
    await prefs.setString(_kLocale, v.locale);
    await _apply();
  }

  Future<void> setRate(double value) async {
    await _ensureReady();
    rate = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kRate, value);
    await _tts.setSpeechRate(value);
  }

  Future<void> setPitch(double value) async {
    await _ensureReady();
    pitch = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kPitch, value);
    await _tts.setPitch(value);
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
