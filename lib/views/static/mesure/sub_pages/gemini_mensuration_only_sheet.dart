import 'package:ateliya/services/gemini_mesure_service.dart';
import 'package:ateliya/services/speech_recognition_service.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';

class GeminiMensurationOnlySheet extends StatefulWidget {
  final void Function(List<MensurationDto>) onMensurationsExtracted;
  final String typePiece;

  const GeminiMensurationOnlySheet({
    super.key,
    required this.onMensurationsExtracted,
    required this.typePiece,
  });

  static Future<void> show(
    BuildContext context, {
    required void Function(List<MensurationDto>) onMensurationsExtracted,
    required String typePiece,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => GeminiMensurationOnlySheet(
            onMensurationsExtracted: onMensurationsExtracted,
            typePiece: typePiece,
          ),
    );
  }

  @override
  State<GeminiMensurationOnlySheet> createState() =>
      _GeminiMensurationOnlySheetState();
}

class _GeminiMensurationOnlySheetState
    extends State<GeminiMensurationOnlySheet> {
  final TextEditingController _textController = TextEditingController();
  final GeminiMesureService _geminiService = GeminiMesureService();
  final SpeechRecognitionService _speech = SpeechRecognitionService();

  bool _isListening = false;
  bool _isLoading = false;
  bool _speechAvailable = false;
  String _speechStatus = "";

  final List<String> _quickSuggestions = [
    "Épaule 16, longueur 18, largeur 57",
    "Tour de poitrine 100, dos 40, col 42",
    "Longueur totale 130, bassin 110",
  ];

  @override
  void initState() {
    super.initState();
    _checkAndInitSpeech();
  }

  Future<void> _checkAndInitSpeech() async {
    _speechAvailable = await _speech.ensureReady(
      onStatus: (val) {
        if (mounted) {
          setState(() {
            _speechStatus = val;
            if (val == 'done' || val == 'notListening') {
              _isListening = false;
              if (_textController.text.isNotEmpty && !_isLoading) {
                _submitQuery();
              }
            }
          });
        }
      },
      onError: (errorMsg) {
        if (mounted) {
          setState(() {
            _isListening = false;
            if (errorMsg == 'error_speech_timeout') {
              if (_textController.text.isEmpty) {
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

  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      await _checkAndInitSpeech();
    }
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
    } else {
      if (_speechAvailable) {
        if (mounted) {
          setState(() {
            _isListening = true;
            _speechStatus = "Écoute en cours...";
          });
        }
        await _speech.listen(
          onResult: (text) {
            if (mounted) {
              setState(() {
                _textController.text = text;
                _speechStatus = "Texte capté !";
              });
            }
          },
        );
      } else {
        CMessageDialog.show(message: "Veuillez autoriser le micro.");
      }
    }
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
      final query = "${widget.typePiece} : $text";
      final result = await _geminiService.extractMesureFromText(query);
      setState(() => _isLoading = false);

      if (result == null ||
          result.typeMesureDto?.mensurations.isEmpty == true) {
        CMessageDialog.show(message: "Aucune mesure n'a pu être extraite.");
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop();

      widget.onMensurationsExtracted(result.typeMesureDto!.mensurations);
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
              "Dicter les mensurations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            const Text(
              "L'IA remplira automatiquement les champs de mesures.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const Gap(16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      _isListening ? AppColors.secondary : Colors.grey.shade200,
                  width: _isListening ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 3,
                    minLines: 2,
                    decoration: InputDecoration(
                      hintText: "Ex: Épaule 16, longueur 18, largeur 57...",
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
                        GestureDetector(
                          onTap: _toggleListening,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _isListening
                                      ? const Color(0xFFDC2626)
                                      : AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isListening
                                      ? Icons.mic
                                      : Icons.mic_none_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const Gap(6),
                                Text(
                                  _isListening ? "Écoute..." : "Parler",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            const Gap(16),
            Text(
              "Exemples rapides :",
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
