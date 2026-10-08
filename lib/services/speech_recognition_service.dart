import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart' show ResultType;
import 'package:speech_to_text/speech_to_text.dart' show LocaleName;

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

  // --- État d'une dictée continue (voir [listen] / [_restartSession]) ---
  bool _continuous = false;
  bool _restarting = false;

  /// Vrai entre [listen] et [stop]. Sert à ignorer les résultats que le moteur
  /// émet encore après la fin d'une dictée.
  bool _active = false;
  void Function(String text)? _onResult;
  Duration _pauseFor = const Duration(seconds: 10);
  Duration _listenFor = const Duration(seconds: 60);

  /// Texte définitivement acquis (résultats finaux + sessions précédentes).
  String _accumulated = '';

  /// Dernier texte complet transmis à l'appelant, même non finalisé : sert de
  /// filet si Android coupe la session sans émettre de résultat final.
  String _lastFull = '';

  /// Dernier texte brut de l'énoncé en cours.
  ///
  /// Le moteur remet `recognizedWords` à zéro à chaque nouvel énoncé, sans
  /// prévenir ni clore la session. Comparer le texte reçu à celui-ci permet de
  /// repérer cette frontière et de figer l'énoncé précédent : sans quoi chaque
  /// nouvelle valeur dictée venait écraser la précédente.
  String _sessionText = '';

  /// Nombre de relances consécutives n'ayant produit aucune parole : au-delà
  /// d'un certain seuil on considère que l'utilisateur a simplement laissé le
  /// micro ouvert et on arrête, plutôt que de relancer indéfiniment.
  int _silentRestarts = 0;

  /// Avec un `pauseFor` de quelques secondes, cela laisse près d'une minute de
  /// silence — le temps de poser le ruban et de lire une mesure — avant que la
  /// dictée ne se coupe d'elle-même. Le compteur repart à zéro dès qu'une
  /// parole est reconnue.
  static const int _maxSilentRestarts = 8;
  bool _sessionGotSpeech = false;

  /// Surveillance « moteur muet ».
  ///
  /// Le `pauseFor` du plugin sert malheureusement à deux choses à la fois : il
  /// est transmis à Android comme durée de silence tolérée avant de clore la
  /// phrase en cours (EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS), et il
  /// arme aussi le minuteur qui coupe la session. Le raccourcir pour récupérer
  /// vite d'un moteur bloqué rendait donc la dictée intolérante aux pauses
  /// naturelles entre deux mesures. On laisse désormais `pauseFor` généreux et
  /// on détecte nous-mêmes l'enlisement avec ce minuteur indépendant.
  Timer? _stuckTimer;
  Duration _stuckAfter = const Duration(seconds: 15);

  /// Dernière fois qu'un son fort (une voix) a été capté, et dernière fois
  /// qu'un texte a été transcrit.
  ///
  /// Comparer les deux distingue les deux silences possibles : celui du
  /// couturier qui prend une mesure — auquel cas il faut surtout NE PAS
  /// toucher à la session, un réveil du moteur coûtant une à trois secondes —
  /// et celui d'un moteur qui n'entend plus rien alors qu'on lui parle.
  DateTime? _lastLoudAt;
  DateTime? _lastResultAt;

  /// Niveau (rmsDB Android) au-delà duquel on considère que quelqu'un parle.
  static const double _speakingLevel = 2.0;

  bool get isAvailable => _available;

  /// Vrai aussi pendant les micro-coupures d'une dictée continue : du point de
  /// vue de l'utilisateur l'écoute n'a pas été interrompue.
  bool get isListening => _speech.isListening || _continuous;

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
        onStatus: _handleStatus,
        onError: (val) => _handleError(val.errorMsg),
      );
      if (_available) {
        try {
          // L'app est entièrement en français (voir Locale('fr','FR') dans
          // main.dart) : on force donc explicitement une locale française
          // pour la reconnaissance plutôt que de dépendre de la locale
          // système, qui peut diverger (région du téléphone mal réglée,
          // etc.) et dégrader nettement la justesse de la transcription.
          final locales = await _speech.locales();
          final french = locales.where((l) => l.localeId.toLowerCase().startsWith('fr'));
          final preferred = french.firstWhere(
            (l) => l.localeId.toLowerCase() == 'fr_fr' || l.localeId.toLowerCase() == 'fr-fr',
            orElse: () => french.isNotEmpty ? french.first : LocaleName('fr_FR', 'Français'),
          );
          _localeId = preferred.localeId;
        } catch (_) {
          _localeId = 'fr_FR';
        }
      }
    } catch (_) {
      _available = false;
    }
    _initialized = true;
    return _available;
  }

  /// Fins de session « normales » que l'on sait rattraper en relançant le
  /// moteur sans rien perdre du texte déjà dicté.
  static const _recoverableErrors = {
    'error_speech_timeout',
    'error_no_match',
    'error_busy',
  };

  void _handleStatus(String val) {
    _log('status=$val continuous=$_continuous restarting=$_restarting');
    final terminal = val == 'done' || val == 'notListening';
    if (terminal && _continuous) {
      // Dictée continue : Android a clos SA session, pas la nôtre. On
      // masque l'événement à l'écran et on rallume le moteur.
      _restartSession('status:$val');
      return;
    }
    _onStatus?.call(val);
  }

  void _handleError(String errorMsg) {
    _log('error=$errorMsg continuous=$_continuous restarting=$_restarting');
    if (_continuous && _recoverableErrors.contains(errorMsg)) {
      _restartSession('error:$errorMsg');
      return;
    }
    if (_continuous) {
      // Erreur réelle (réseau, permission...) : on sort du mode continu et on
      // laisse l'écran reprendre la main.
      _continuous = false;
    }
    _onError?.call(errorMsg);
  }

  /// Relance une session de reconnaissance après qu'Android a coupé la
  /// précédente.
  ///
  /// C'est le cœur de la dictée continue. Sur Android, `SpeechRecognizer`
  /// **termine définitivement** la reconnaissance dès qu'il livre son résultat
  /// final (`onResults`) — le moteur est éteint, même si `ListenMode.dictation`
  /// est demandé. Pire, le plugin ne s'en rend pas compte : il n'annonce la fin
  /// de l'écoute qu'au bout du minuteur `pauseFor` armé par `onEndOfSpeech`.
  /// Entre les deux, l'app croit écouter alors que plus rien n'est capté —
  /// c'est exactement ce qu'on observait : deux ou trois valeurs dictées puis
  /// un « Écoute en cours… » qui tourne dans le vide.
  ///
  /// D'où la relance déclenchée dès le résultat final, sans attendre le
  /// minuteur. Elle doit impérativement passer par un [stt.SpeechToText.stop] :
  /// côté natif, `startListening` refuse de démarrer tant que le plugin se
  /// croit en écoute, et c'est `stop` qui annule le minuteur en attente (sans
  /// quoi il viendrait plus tard couper la session suivante).
  Future<void> _restartSession(String cause) async {
    if (!_continuous || _restarting) {
      _log('restart ignoré ($cause) continuous=$_continuous restarting=$_restarting');
      return;
    }
    _restarting = true;

    // Ce que la session qui vient de finir a produit est définitivement acquis.
    if (_lastFull.length > _accumulated.length) _accumulated = _lastFull;

    if (_sessionGotSpeech) {
      _silentRestarts = 0;
    } else {
      _silentRestarts++;
    }
    _sessionGotSpeech = false;
    _log('restart ($cause) acquis="$_accumulated" silences=$_silentRestarts');

    if (_silentRestarts >= _maxSilentRestarts) {
      _continuous = false;
      _active = false;
      _restarting = false;
      _stuckTimer?.cancel();
      await _speech.stop();
      _log('arrêt : trop de silences consécutifs');
      _onStatus?.call('done');
      return;
    }

    try {
      await _speech.stop();
      // Le plugin détruit son recognizer avec 50 ms de délai, et Android
      // renvoie ERROR_RECOGNIZER_BUSY si on redémarre trop vite : on laisse
      // une marge, assez courte pour rester imperceptible à la dictée.
      await Future.delayed(const Duration(milliseconds: 300));
      if (!_continuous) {
        _restarting = false;
        return;
      }
      await _startSession();
      _log('session relancée');
      // Les événements de fin de la session PRÉCÉDENTE peuvent arriver après
      // coup : on continue de les absorber un court instant, sinon ils
      // couperaient aussitôt la session qu'on vient de rallumer.
      await Future.delayed(const Duration(milliseconds: 600));
    } catch (e) {
      _continuous = false;
      _active = false;
      _log('échec de relance : $e');
      _onStatus?.call('done');
    }
    _restarting = false;
  }

  /// (Ré)arme la surveillance : si plus rien n'est transcrit pendant
  /// [_stuckAfter], on considère le moteur enlisé et on le relance.
  void _armStuckTimer() {
    _stuckTimer?.cancel();
    if (!_continuous) return;
    _stuckTimer = Timer(_stuckAfter, () {
      if (!_continuous || _restarting) return;
      final loud = _lastLoudAt;
      final parleDepuisDernierTexte = loud != null &&
          (_lastResultAt == null || loud.isAfter(_lastResultAt!));
      if (!parleDepuisDernierTexte) {
        // Vrai silence : on mesure, on ne parle pas. Relancer le moteur ici
        // ne ferait qu'imposer un temps de réveil au moment où la dictée
        // reprend. On laisse donc la session ouverte et on resurveille.
        _log('silence réel : session laissée ouverte');
        _armStuckTimer();
        return;
      }
      _log('voix captée mais rien transcrit depuis ${_stuckAfter.inSeconds}s');
      _restartSession('moteur muet');
    });
  }

  Future<void> _startSession() {
    _armStuckTimer();
    _sessionText = '';
    return _speech.listen(
      onSoundLevelChange: (level) {
        if (level > _speakingLevel) _lastLoudAt = DateTime.now();
      },
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        cancelOnError: false,
        autoPunctuation: true,
        pauseFor: _pauseFor,
        listenFor: _listenFor,
        localeId: _localeId,
      ),
      onResult: (val) {
        final text = val.recognizedWords.trim();
        final type = val.resultTypeValue;
        _log('résultat type=$type brut="$text" acquis="$_accumulated" '
            'énoncé="$_sessionText"');
        if (text.isEmpty) return;
        // Le moteur continue d'émettre après un `stop()` (résultats tardifs de
        // la session close). Les laisser passer rouvrait la dictée côté écran
        // alors qu'elle était terminée, et le texte s'y retrouvait recollé une
        // seconde fois — d'où la série qui repartait du début.
        if (!_active) {
          _log('  -> ignoré (dictée déjà arrêtée)');
          return;
        }
        _sessionGotSpeech = true;
        _lastResultAt = DateTime.now();
        _armStuckTimer();

        // Filet de secours quand le moteur ne signale pas la frontière : si le
        // texte reçu n'est ni un prolongement ni une correction de l'énoncé en
        // cours, c'est qu'il a recommencé à zéro. On fige alors le précédent
        // avant d'enchaîner, sinon la nouvelle valeur écrase l'ancienne.
        final lower = text.toLowerCase();
        final prec = _sessionText.toLowerCase();
        final memeEnonce =
            prec.isEmpty || lower.startsWith(prec) || prec.startsWith(lower);
        if (!memeEnonce) {
          _accumulated = _merge(_accumulated, _sessionText);
          _log('  nouvel énoncé détecté -> acquis="$_accumulated"');
        }
        _sessionText = text;

        final full = _merge(_accumulated, text);
        _lastFull = full;
        _log('  -> transmis "$full"');
        _onResult?.call(full);

        // `intermediate` = le moteur clôt l'énoncé courant mais poursuit
        // l'écoute ; `finalResult` = il clôt toute la session. Dans les deux
        // cas le prochain texte repartira d'une page blanche, donc on fige.
        if (type == ResultType.intermediate || val.finalResult) {
          _accumulated = full;
          _sessionText = '';
        }
        if (val.finalResult && _continuous) {
          // Résultat final = moteur éteint côté Android. On le rallume tout de
          // suite pour que la dictée se poursuive sans trou.
          _restartSession('finalResult');
        }
      },
    );
  }

  /// Traces du déroulé d'une dictée. Conservées (en debug seulement) parce que
  /// les anomalies de reconnaissance ne se diagnostiquent pas autrement : le
  /// comportement du moteur varie d'un appareil à l'autre.
  void _log(String msg) {
    if (kDebugMode) debugPrint('STT/ $msg');
  }

  /// Concatène le texte déjà acquis et le nouvel énoncé.
  ///
  /// Selon les appareils, le moteur repart soit d'une page blanche après un
  /// résultat final, soit au contraire poursuit la même transcription : dans ce
  /// second cas une simple concaténation dupliquerait tout le début.
  String _merge(String base, String text) {
    if (base.isEmpty) return text;
    if (text.toLowerCase().startsWith(base.toLowerCase())) return text;

    // En changeant d'énoncé, le moteur réémet souvent la fin du précédent au
    // début du suivant : « ... dos 50 » puis « dos 50 épaule 40 ». On retire ce
    // chevauchement — mais seulement s'il comporte un mot, car une répétition
    // de nombres nus (« 13 13 ») peut être parfaitement voulue.
    final motsBase = base.split(RegExp(r'\s+'));
    final motsTexte = text.split(RegExp(r'\s+'));
    final maxChevauchement =
        motsBase.length < motsTexte.length ? motsBase.length : motsTexte.length;
    for (var k = maxChevauchement; k > 0; k--) {
      final queue = motsBase.sublist(motsBase.length - k);
      final tete = motsTexte.sublist(0, k);
      var identiques = true;
      for (var i = 0; i < k; i++) {
        if (queue[i].toLowerCase() != tete[i].toLowerCase()) {
          identiques = false;
          break;
        }
      }
      if (identiques && queue.any((m) => !_estNombre(m))) {
        return [...motsBase, ...motsTexte.sublist(k)].join(' ');
      }
    }
    return '$base $text';
  }

  static final _motifNombre = RegExp(r'^\d+([.,]\d+)?$');
  bool _estNombre(String mot) => _motifNombre.hasMatch(mot);

  /// Démarre une dictée.
  ///
  /// [continuous] relance automatiquement le moteur à chaque fois qu'Android
  /// clôt sa session, jusqu'à un [stop] explicite : indispensable pour dicter
  /// une longue série de valeurs d'affilée.
  Future<void> listen({
    required void Function(String text) onResult,
    // Durée de silence qu'Android tolère avant de clore la phrase en cours.
    // Généreuse : chaque clôture coûte un redémarrage du moteur, donc une à
    // trois secondes pendant lesquelles la parole n'est pas captée.
    Duration pauseFor = const Duration(seconds: 25),
    // Plafond de durée d'une session. Volontairement très au-delà d'une dictée
    // réelle : le découpage utile est géré par [_stuckAfter], pas ici.
    Duration listenFor = const Duration(minutes: 5),
    // Délai sans aucune transcription au bout duquel on relance le moteur.
    Duration stuckAfter = const Duration(seconds: 15),
    bool continuous = false,
  }) {
    _onResult = onResult;
    _pauseFor = pauseFor;
    _listenFor = listenFor;
    _stuckAfter = stuckAfter;
    _continuous = continuous;
    _restarting = false;
    _accumulated = '';
    _lastFull = '';
    _silentRestarts = 0;
    _sessionGotSpeech = false;
    _lastLoudAt = null;
    _lastResultAt = null;
    _active = true;
    _log('listen() continuous=$continuous pauseFor=${pauseFor.inSeconds}s locale=$_localeId');
    return _startSession();
  }

  Future<void> stop() async {
    _continuous = false;
    _active = false;
    _stuckTimer?.cancel();
    _stuckTimer = null;
    _log('stop() demandé');
    await _speech.stop();
  }
}
