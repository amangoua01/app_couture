import 'package:ateliya/services/gemini_assistant_service.dart';
import 'package:ateliya/services/speech_recognition_service.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/tools/widgets/voice/hold_to_talk_mic_button.dart';
import 'package:ateliya/views/static/depense/edition_depense_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GeminiAssistantSheet extends StatefulWidget {
  const GeminiAssistantSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const GeminiAssistantSheet(),
    );
  }

  @override
  State<GeminiAssistantSheet> createState() => _GeminiAssistantSheetState();
}

class _GeminiAssistantSheetState extends State<GeminiAssistantSheet> {
  final TextEditingController _textController = TextEditingController();
  final GeminiAssistantService _geminiService = GeminiAssistantService();
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
    "Achat 5 bobines de fil et aiguilles pour 7 500 FCFA",
    "Paiement facture d'électricité CIE 28 000 FCFA",
    "Réparation machine à coudre Singer 15 000 FCFA",
    "Achat fermetures éclair et doublures 12 000 FCFA",
    "Transport taxi livraison tissu client 3 500 FCFA",
  ];

  @override
  void initState() {
    super.initState();
    _checkAndInitSpeech();
  }

  Future<void> _checkAndInitSpeech() async {
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
                _speechStatus =
                    "Aucune voix détectée. Vous pouvez parler plus près du micro ou taper votre dépense.";
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
          _speechStatus = "Écoute en cours... Parlez maintenant";
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
          setState(() {
            _textController.text =
                _committedText.isEmpty ? text : "$_committedText $text";
            _speechStatus = "Texte capté !";
          });
        },
      );
    } else {
      CMessageDialog.show(
        message:
            "Veuillez autoriser l'accès au microphone dans les paramètres de votre téléphone pour dicter vos dépenses.",
      );
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
      CMessageDialog.show(
        message: "Veuillez saisir ou dicter votre dépense d'abord.",
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }

    setState(() => _isLoading = true);

    try {
      final result = await _geminiService.extractDepenseFromText(text);

      setState(() => _isLoading = false);

      if (result == null ||
          (result.montant == null &&
              (result.description == null || result.description!.isEmpty))) {
        CMessageDialog.show(
          message:
              "Gemini n'a pas pu identifier le montant ou le motif. Essayez de préciser : 'Achat de tissu 15000 FCFA'.",
        );
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop();

      // Navigue vers la création avec les données extraites
      Get.to(() => EditionDepensePage(initialData: result));
    } catch (e) {
      setState(() => _isLoading = false);
      CMessageDialog.show(message: "Erreur lors de l'analyse : $e");
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
            // Poignée supérieure
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

            // En-tête Assistant Ateliya
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF135E4E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Assistant IA Gemini",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const Gap(6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "BETA",
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF92671A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(2),
                      Text(
                        "Dictez ou écrivez votre dépense librement",
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                ),
              ],
            ),
            const Gap(16),

            if (_isListening)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF87171)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.mic, color: Color(0xFFDC2626), size: 22),
                    Gap(10),
                    Expanded(
                      child: Text(
                        "Microphone activé ! Parlez maintenant...\n(Si vous portez des écouteurs Bluetooth, parlez dedans)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB91C1C),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (_speechStatus.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFB45309),
                      size: 18,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        _speechStatus,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Champ de texte avec bouton micro intégré
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          "Ex: J'ai acheté des fils et des fermetures pour 8 000 FCFA...",
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_textController.text.isNotEmpty &&
                            !_isListening &&
                            !_locked &&
                            !_pausedWhileLocked)
                          GestureDetector(
                            onTap: () {
                              _textController.clear();
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.clear_rounded,
                                  size: 16,
                                  color: Colors.grey.shade500,
                                ),
                                const Gap(4),
                                Text(
                                  "Effacer",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox.shrink(),

                        // Bouton micro — appui maintenu façon WhatsApp,
                        // verrouillable en glissant vers la droite
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
            const Gap(16),

            // Suggestions rapides de test
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_outward_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const Gap(6),
                            Flexible(
                              child: Text(
                                suggestion,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const Gap(24),

            // Bouton Analyser & Remplir
            CButton(
              isLoading: _isLoading,
              title: "Analyser & Pré-remplir la dépense",
              onPressed: () => _submitQuery(),
            ),
          ],
        ),
      ),
    );
  }
}
