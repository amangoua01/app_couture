import 'dart:async';

import 'package:ateliya/api/assistant_api.dart';
import 'package:ateliya/data/models/assistant/assistant_balance.dart';
import 'package:ateliya/data/models/assistant/assistant_message.dart';
import 'package:ateliya/services/assistant_speech_service.dart';
import 'package:ateliya/services/speech_recognition_service.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

/// Échec du dernier envoi, avec ce qu'il faut proposer à l'utilisateur.
class AssistantFailure {
  final String message;

  /// Solde insuffisant : on propose de recharger plutôt que de réessayer.
  final bool insufficientTokens;

  const AssistantFailure(this.message, {this.insufficientTokens = false});
}

class AssistantChatPageVctl extends AuthViewController {
  static const maxLength = 1000;

  final api = AssistantApi();
  final inputCtl = TextEditingController();
  final scrollCtl = ScrollController();

  final List<AssistantMessage> messages = [];
  AssistantBalance balance = const AssistantBalance();
  bool balanceLoaded = false;
  int? conversationId;
  bool isSending = false;
  bool isLoadingHistory = false;
  AssistantFailure? failure;

  /// Dernière question non aboutie, pour proposer « Réessayer ».
  String? _pendingQuestion;

  // --- Voix ---
  final _speech = SpeechRecognitionService();
  final _voice = AssistantSpeechService();

  /// Vrai pendant que le micro écoute.
  bool isListening = false;

  /// Indice du message de Sika actuellement lu à voix haute.
  int? speakingIndex;

  /// Texte déjà présent dans le champ quand la dictée a commencé : la voix s'y ajoute.
  String _dictationBase = '';

  /// La question en cours a été dictée : Sika lit alors sa réponse à voix haute.
  bool _askedByVoice = false;

  AssistantChatPageVctl({int? openConversationId})
      : conversationId = openConversationId;

  bool get hasMessages => messages.isNotEmpty;

  bool get canSend =>
      !isSending && inputCtl.text.trim().isNotEmpty;

  @override
  void onReady() {
    loadBalance();
    if (conversationId != null) {
      openConversation(conversationId!);
    }
    super.onReady();
  }

  Future<void> loadBalance() async {
    final res = await api.balance();
    if (res.status) {
      balance = res.data!;
      balanceLoaded = true;
      update();
    } else if (!balanceLoaded && (res.statusCode == 403 || res.statusCode == 404)) {
      // Accès refusé (profil ou abonnement) ou assistant absent du serveur : on l'affiche.
      failure = AssistantFailure(res.message);
      update();
    }
  }

  Future<void> openConversation(int id) async {
    await _stopSpeaking();
    isLoadingHistory = true;
    conversationId = id;
    messages.clear();
    failure = null;
    update();

    final res = await api.messages(id);
    isLoadingHistory = false;
    if (res.status) {
      messages.addAll(res.data!);
    } else {
      failure = AssistantFailure(res.message);
    }
    update();
    _scrollToEnd(jump: true);
  }

  void newConversation() {
    if (isSending) return;
    _stopSpeaking();
    _stopListening();
    conversationId = null;
    messages.clear();
    failure = null;
    _pendingQuestion = null;
    inputCtl.clear();
    update();
  }

  /// Envoie [text] (ou le contenu du champ de saisie). [byVoice] : la question
  /// vient d'être dictée, la réponse sera lue à voix haute.
  Future<void> send([String? text, bool byVoice = false]) async {
    final question = (text ?? inputCtl.text).trim();
    if (question.isEmpty || isSending) return;

    await _stopSpeaking();
    _askedByVoice = byVoice;

    failure = null;
    _pendingQuestion = question;
    messages.add(AssistantMessage(fromUser: true, contenu: question));
    inputCtl.clear();
    isSending = true;
    update();
    _scrollToEnd();

    final res = await api.chat(
      message: question,
      conversationId: conversationId,
    );
    isSending = false;

    if (res.status) {
      final reply = res.data!;
      conversationId = reply.conversationId;
      messages.add(reply.message);
      balance = balance.copyWithTotals(
        soldeForfait: reply.soldeForfait,
        soldePacks: reply.soldePacks,
      );
      _pendingQuestion = null;
      if (_askedByVoice) {
        // Question dictée : on répond de vive voix (un message de plus, donc indice length - 1).
        unawaited(toggleSpeak(messages.length - 1));
      }
    } else {
      failure = AssistantFailure(
        res.message,
        insufficientTokens: res.statusCode == 402,
      );
    }
    update();
    _scrollToEnd();
  }

  /// Renvoie la dernière question qui n'a pas abouti, sans la dupliquer dans le fil.
  Future<void> retry() async {
    final question = _pendingQuestion;
    if (question == null || isSending) return;
    if (messages.isNotEmpty && messages.last.fromUser) {
      messages.removeLast();
    }
    await send(question);
  }

  // ---------------------------------------------------------------------------
  // Dictée : le micro remplit le champ ; au silence, la question part toute seule.
  // ---------------------------------------------------------------------------

  /// Touche le micro : démarre la dictée, ou l'arrête (le texte reste dans le
  /// champ pour être relu, corrigé puis envoyé à la main).
  Future<void> toggleMic() async {
    if (isListening) {
      await _stopListening();
      return;
    }
    if (isSending) return;
    await _startListening();
  }

  Future<void> _startListening() async {
    // Le micro ne doit jamais entendre la voix de Sika.
    await _stopSpeaking();

    final ready = await _speech.ensureReady(
      onStatus: (status) {
        // Fin de phrase détectée par le moteur : la question part.
        if ((status == 'done' || status == 'notListening') && isListening) {
          _onSpeechEnded();
        }
      },
      onError: (_) {
        if (isListening) {
          isListening = false;
          update();
        }
      },
    );
    if (!ready) {
      CMessageDialog.show(
        message:
            "Autorisez l'accès au microphone dans les paramètres du téléphone pour poser vos questions à voix haute.",
      );
      return;
    }

    _dictationBase = inputCtl.text.trim();
    isListening = true;
    failure = null;
    update();

    await _speech.listen(
      // Android clôt la phrase après ce silence : c'est le « j'ai fini de parler ».
      pauseFor: const Duration(seconds: 3),
      listenFor: const Duration(seconds: 45),
      onResult: (text) {
        if (!isListening) return;
        final heard = text.trim();
        inputCtl.text = _dictationBase.isEmpty ? heard : '$_dictationBase $heard';
        inputCtl.selection = TextSelection.collapsed(offset: inputCtl.text.length);
        update();
      },
    );
  }

  /// Arrêt demandé par l'utilisateur : on garde le texte capté sans l'envoyer.
  Future<void> _stopListening() async {
    if (!isListening) return;
    isListening = false;
    update();
    await _speech.stop();
  }

  /// Le moteur s'est arrêté de lui-même (silence) : s'il y a une question, on l'envoie.
  void _onSpeechEnded() {
    isListening = false;
    update();
    final heardSomething = inputCtl.text.trim().length > _dictationBase.length;
    if (heardSomething && canSend) {
      send(null, true);
    }
  }

  // ---------------------------------------------------------------------------
  // Lecture à voix haute d'une réponse
  // ---------------------------------------------------------------------------

  /// Lit la réponse n° [index] ; une seconde touche sur la même réponse l'arrête.
  Future<void> toggleSpeak(int index) async {
    if (index < 0 || index >= messages.length || messages[index].fromUser) return;

    if (speakingIndex == index) {
      await _stopSpeaking();
      return;
    }
    await _stopListening();
    await _stopSpeaking();

    speakingIndex = index;
    update();
    final started = await _voice.speak(
      messages[index].contenu,
      onDone: () {
        if (speakingIndex == index) {
          speakingIndex = null;
          update();
        }
      },
    );
    if (!started) {
      speakingIndex = null;
      update();
      CMessageDialog.show(
        message: "La lecture à voix haute n'est pas disponible en français sur ce téléphone.",
      );
    }
  }

  Future<void> _stopSpeaking() async {
    if (speakingIndex == null) return;
    speakingIndex = null;
    update();
    await _voice.stop();
  }

  void _scrollToEnd({bool jump = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollCtl.hasClients) return;
      final end = scrollCtl.position.maxScrollExtent;
      if (jump) {
        scrollCtl.jumpTo(end);
      } else {
        scrollCtl.animateTo(
          end,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _voice.stop();
    _speech.stop();
    inputCtl.dispose();
    scrollCtl.dispose();
    super.onClose();
  }
}
