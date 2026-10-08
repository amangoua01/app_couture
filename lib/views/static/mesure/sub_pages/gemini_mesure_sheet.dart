import 'package:ateliya/services/gemini_mesure_service.dart';
import 'package:ateliya/services/speech_recognition_service.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/utils/couture_vocabulary.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/tools/widgets/voice/hold_to_talk_mic_button.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ateliya/views/static/mesure/edition_piece_couture_page.dart';
import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';

class GeminiMesureSheet extends StatefulWidget {
  final void Function(LigneMesureDto) onPieceAdded;

  const GeminiMesureSheet({super.key, required this.onPieceAdded});

  static Future<void> show(
    BuildContext context, {
    required void Function(LigneMesureDto) onPieceAdded,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GeminiMesureSheet(onPieceAdded: onPieceAdded),
    );
  }

  @override
  State<GeminiMesureSheet> createState() => _GeminiMesureSheetState();
}

class _GeminiMesureSheetState extends State<GeminiMesureSheet> {
  final TextEditingController _textController = TextEditingController();
  final GeminiMesureService _geminiService = GeminiMesureService();
  final SpeechRecognitionService _speech = SpeechRecognitionService();

  bool _isListening = false;
  bool _isLoading = false;
  bool _speechAvailable = false;
  String _speechStatus = "";

  // Verrouillage "mains libres" (glisser le bouton micro) : le texte déjà
  // reconnu avant une pause est conservé ici pour que les segments dictés
  // s'accumulent plutôt que de s'écraser.
  bool _locked = false;
  bool _pausedWhileLocked = false;
  String _committedText = "";

  final List<String> _quickSuggestions = [
    "Costume col 40, épaule 45, poitrine 100",
    "Pantalon taille 42, longueur 105, cuisse 60",
    "Robe de soirée longueur totale 130",
  ];

  @override
  void initState() {
    super.initState();
    _checkAndInitSpeech();
  }

  Future<void> _checkAndInitSpeech() async {
    // Ne coûte réellement cher qu'au tout premier appel de l'app : les
    // ouvertures suivantes de cette fenêtre (ou des autres assistants
    // vocaux) réutilisent le moteur déjà initialisé.
    _speechAvailable = await _speech.ensureReady(
      onStatus: (val) {
        debugPrint("SpeechToText onStatus: $val");
        if (!mounted) return;
        // Le plugin envoie souvent 'done' PUIS 'notListening' pour la même
        // fin de session : sans ce garde, le second événement déclenchait
        // un second redémarrage en double, source du texte qui se
        // réinitialisait de façon aléatoire pendant l'écoute verrouillée.
        if ((val == 'done' || val == 'notListening') && !_isListening) {
          return;
        }
        setState(() {
          _speechStatus = val;
          if (val == 'done' || val == 'notListening') {
            _isListening = false;
            if (_locked) {
              // Pause naturelle du moteur (silence prolongé) pendant qu'on
              // est verrouillé : le texte déjà dicté est conservé, mais on
              // attend un "Reprendre" explicite plutôt que de redémarrer
              // tout seul — un redémarrage automatique s'est révélé peu
              // fiable avec ce plugin (deux chemins d'arrêt à synchroniser).
              _committedText = _textController.text;
              _pausedWhileLocked = true;
            } else if (_textController.text.isNotEmpty && !_isLoading) {
              _submitQuery();
            }
          }
        });
      },
      onError: (errorMsg) {
        debugPrint("SpeechToText onError: $errorMsg");
        if (mounted) {
          setState(() {
            _isListening = false;
            if (errorMsg == 'error_speech_timeout' || errorMsg == 'error_no_match') {
              if (_locked) {
                _committedText = _textController.text;
                _pausedWhileLocked = true;
              } else if (_textController.text.isEmpty) {
                _speechStatus = "Aucune voix détectée.";
              }
            } else {
              _speechStatus = "Info micro : $errorMsg";
            }
          });
        }
      },
    );
    if (mounted) setState(() {});
  }

  // Appui maintenu façon WhatsApp : on écoute tant que le doigt reste sur
  // le bouton, on arrête dès qu'il se lève.
  Future<void> _startListening() async {
    if (_isListening) return;
    if (!_speechAvailable) {
      await _checkAndInitSpeech();
    }
    if (_speechAvailable) {
      if (mounted) {
        setState(() {
          _isListening = true;
          _speechStatus = "Écoute en cours...";
        });
      }
      await _speech.listen(
        // Android éteint son moteur à chaque énoncé reconnu : sans relance
        // automatique, la dictée s'arrête d'elle-même au bout d'une phrase.
        continuous: true,
        onResult: (text) {
          // Le moteur émet encore des résultats après l'arrêt de la session.
          // Les accepter ici les recollait derrière le texte déjà figé dans
          // [_committedText], et la dictée se retrouvait écrite en double.
          if (!mounted || !_isListening) return;
          // La reconnaissance vocale ignore le vocabulaire du métier : elle
          // entend « d'eau » pour « dos », « colle » pour « col ». On rétablit
          // la terminologie avant affichage, pour que le couturier lise ce
          // qu'il a dit et que l'extraction travaille sur les bons mots.
          final dicte = corrigerVocabulaireCouture(text);
          setState(() {
            _textController.text =
                _committedText.isEmpty ? dicte : "$_committedText $dicte";
            _speechStatus = "Texte capté !";
          });
        },
      );
    } else {
      CMessageDialog.show(message: "Veuillez autoriser le micro.");
    }
  }

  Future<void> _stopListening() async {
    if (!_isListening) return;
    await _speech.stop();
    if (mounted) setState(() => _isListening = false);
  }

  Future<void> _resumeListening() async {
    setState(() => _pausedWhileLocked = false);
    await _startListening();
  }

  @override
  void dispose() {
    _speech.stop();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitQuery([String? customText]) async {
    final text = customText ?? _textController.text.trim();
    if (text.isEmpty) {
      CMessageDialog.show(message: "Veuillez dicter ou écrire les mesures.");
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }

    setState(() => _isLoading = true);

    try {
      final result = await _geminiService.extractMesureFromText(text);
      setState(() => _isLoading = false);

      if (result == null ||
          (result.typeMesureDto?.mensurations.isEmpty == true &&
              result.typeMesureDto?.libelle == null)) {
        CMessageDialog.show(message: "Aucune mesure n'a pu être extraite.");
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop();

      // Ouvre EditionPieceCouturePage avec les données pré-remplies
      final res = await Get.to(() => EditionPieceCouturePage(ligne: result));
      if (res is LigneMesureDto) {
        widget.onPieceAdded(res);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      CMessageDialog.show(message: "Erreur : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(16),
            const Text(
              "Dicter les mesures",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            const Text(
              "L'IA va extraire automatiquement le vêtement et ses mesures associées.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const Gap(16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (_isListening || _locked)
                      ? AppColors.secondary
                      : Colors.grey.shade200,
                  width: (_isListening || _locked) ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 3,
                    minLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          "Ex: Chemise manches longues, cou 40, épaules 42...",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: HoldToTalkMicButton(
                            isListening: _isListening,
                            onHoldStart: _startListening,
                            onHoldRelease: _stopListening,
                            onLock: () => setState(() => _locked = true),
                            isPaused: _pausedWhileLocked,
                            onResume: _resumeListening,
                            onValidate: () async {
                              setState(() {
                                _locked = false;
                                _pausedWhileLocked = false;
                              });
                              await _stopListening();
                              await _submitQuery();
                            },
                            onCancel: () async {
                              setState(() {
                                _locked = false;
                                _pausedWhileLocked = false;
                              });
                              await _stopListening();
                              if (mounted) {
                                setState(() {
                                  _textController.clear();
                                  _committedText = "";
                                  _speechStatus = "";
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Sans message à afficher, cette ligne ne laissait qu'une icône
            // orange isolée au milieu de la fenêtre.
            if (_speechStatus.isNotEmpty) ...[
              const Gap(8),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFB45309),
                    size: 16,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      _speechStatus,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const Gap(16),
            Text(
              "Exemples rapides à tester :",
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _quickSuggestions.map((suggestion) {
                    return InkWell(
                      onTap: () {
                        _textController.text = suggestion;
                        setState(() {});
                        _submitQuery(suggestion);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Text(
                          suggestion,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const Gap(24),
            CButton(
              isLoading: _isLoading,
              title: "Analyser & Pré-remplir",
              onPressed: () => _submitQuery(),
            ),
          ],
        ),
      ),
    );
  }
}
