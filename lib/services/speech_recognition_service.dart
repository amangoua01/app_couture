import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Reconnaissance vocale partagée par tous les assistants dictés de l'app.
///
/// Avant ce service, chaque fenêtre (dépense, mesure, mensuration) créait
/// sa propre instance de [stt.SpeechToText] et refaisait la vérification de
/// permission + l'initialisation du moteur à CHAQUE ouverture — un aller-
/// retour notable avant même que l'utilisateur puisse parler. Ici,
/// l'initialisation ne se fait qu'une seule fois pour toute la session ; les
/// ouvertures suivantes réutilisent le moteur déjà prêt.
///
/// Les callbacks `onStatus`/`onError` du plugin ne peuvent être enregistrés
/// qu'une fois, au premier `initialize()` : [ensureReady] les redirige donc
/// vers les callbacks les plus récemment fournis, pour que chaque fenêtre
/// reçoive bien ses propres mises à jour sans repayer le coût d'init.
class SpeechRecognitionService {
  static final SpeechRecognitionService _instance =
      SpeechRecognitionService._internal();
  factory SpeechRecognitionService() => _instance;
  SpeechRecognitionService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _initialized = false;
  bool _available = false;
  String? _localeId;

  void Function(String status)? _onStatus;
  void Function(String errorMsg)? _onError;

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;

  Future<bool> _requestMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;
    final res = await Permission.microphone.request();
    return res.isGranted;
  }

  /// À appeler avant tout `listen()`. Ne réalise le vrai travail
  /// d'initialisation qu'une seule fois par session ; les appels suivants
  /// se contentent de rebrancher les callbacks et répondent immédiatement.
  Future<bool> ensureReady({
    void Function(String status)? onStatus,
    void Function(String errorMsg)? onError,
  }) async {
    _onStatus = onStatus;
    _onError = onError;

    final hasPerm = await _requestMicrophonePermission();
    if (!hasPerm) {
      _available = false;
      return false;
    }

    if (_initialized) return _available;

    try {
      _available = await _speech.initialize(
        onStatus: (val) => _onStatus?.call(val),
        onError: (val) => _onError?.call(val.errorMsg),
      );
      if (_available) {
        try {
          final sysLocale = await _speech.systemLocale();
          _localeId = sysLocale?.localeId;
        } catch (_) {
          // Pas bloquant : listen() fonctionne aussi sans localeId explicite.
        }
      }
    } catch (_) {
      _available = false;
    }
    _initialized = true;
    return _available;
  }

  Future<void> listen({required void Function(String text) onResult}) {
    return _speech.listen(
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        cancelOnError: false,
        autoPunctuation: true,
        pauseFor: const Duration(seconds: 5),
        listenFor: const Duration(seconds: 30),
        localeId: _localeId,
      ),
      onResult: (val) {
        if (val.recognizedWords.isNotEmpty) onResult(val.recognizedWords);
      },
    );
  }

  Future<void> stop() => _speech.stop();
}
