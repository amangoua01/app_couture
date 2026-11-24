import 'package:ateliya/services/assistant_speech_service.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Choix de la voix de Sika : voix françaises du téléphone, vitesse et ton,
/// avec un exemple à écouter. Tout se mémorise.
class AssistantVoiceSheet extends StatefulWidget {
  const AssistantVoiceSheet({super.key});

  @override
  State<AssistantVoiceSheet> createState() => _AssistantVoiceSheetState();
}

class _AssistantVoiceSheetState extends State<AssistantVoiceSheet> {
  static const _sample = "Bonjour, je suis Sika, votre assistante. Aujourd'hui, votre chiffre d'affaires est de cent vingt-cinq mille francs CFA.";

  final _voice = AssistantSpeechService();
  late final Future<List<AssistantVoice>> _voices = _voice.frenchVoices();
  bool _playing = false;

  @override
  void dispose() {
    _voice.stop();
    super.dispose();
  }

  Future<void> _preview() async {
    setState(() => _playing = true);
    final ok = await _voice.speak(_sample, onDone: () {
      if (mounted) setState(() => _playing = false);
    });
    if (!ok && mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.ligthGrey, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              const Text("Voix de Sika", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textDark)),
              const SizedBox(height: 4),
              const Text(
                "Choisissez la voix qui vous plaît. Les voix « haute qualité » sonnent le plus naturellement.",
                style: TextStyle(fontSize: 12.5, height: 1.4, color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: FutureBuilder<List<AssistantVoice>>(
                  future: _voices,
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                      );
                    }
                    final voices = snap.data ?? const [];
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        if (voices.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "Aucune voix française n'est installée. Ajoutez-en dans les réglages du téléphone (Synthèse vocale).",
                              style: TextStyle(color: AppColors.textMuted, height: 1.4),
                            ),
                          ),
                        for (var i = 0; i < voices.length; i++) _voiceTile(voices[i], i),
                        const SizedBox(height: 10),
                        _slider(
                          label: "Vitesse",
                          value: _voice.rate,
                          min: 0.3,
                          max: 0.7,
                          onChanged: (v) => setState(() => _voice.rate = v),
                          onChangeEnd: _voice.setRate,
                          leftHint: "Posée",
                          rightHint: "Rapide",
                        ),
                        _slider(
                          label: "Ton",
                          value: _voice.pitch,
                          min: 0.8,
                          max: 1.3,
                          onChanged: (v) => setState(() => _voice.pitch = v),
                          onChangeEnd: _voice.setPitch,
                          leftHint: "Grave",
                          rightHint: "Aigu",
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _playing ? () async { await _voice.stop(); } : _preview,
                  icon: Icon(_playing ? Icons.stop_rounded : Icons.volume_up_rounded),
                  label: Text(_playing ? "Arrêter" : "Écouter un exemple"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _voiceTile(AssistantVoice v, int index) {
    final selected = _voice.voice?.name == v.name && _voice.voice?.locale == v.locale;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        await _voice.selectVoice(v);
        if (mounted) setState(() {});
        await _preview(); // on entend tout de suite la voix choisie
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.10),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: selected ? AppColors.primary : AppColors.textMuted,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Voix ${index + 1}${index == 0 ? ' (recommandée)' : ''}",
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark),
                  ),
                  Text(
                    "${v.qualityLabel}, ${v.network ? 'nécessite internet' : 'hors ligne'}, ${v.locale}",
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required Future<void> Function(double) onChangeEnd,
    required String leftHint,
    required String rightHint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark)),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: 20,
            activeColor: AppColors.primary,
            onChanged: onChanged,
            onChangeEnd: (v) async {
              await onChangeEnd(v);
              await _preview();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(leftHint, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                Text(rightHint, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
