import 'package:ateliya/data/models/assistant/assistant_message.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/views/static/assistant/assistant_tool_labels.dart';
import 'package:ateliya/views/static/assistant/widgets/assistant_rich_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bulle d'un message : à droite (vert) pour l'utilisateur, à gauche (blanche) pour Sika.
class AssistantBubble extends StatelessWidget {
  final AssistantMessage message;

  /// Vrai pendant que cette réponse est lue à voix haute.
  final bool isSpeaking;

  /// Touche « Écouter » / « Arrêter » ; null masque le bouton.
  final VoidCallback? onSpeak;

  const AssistantBubble(
    this.message, {
    super.key,
    this.isSpeaking = false,
    this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    final fromUser = message.fromUser;
    final maxWidth = MediaQuery.of(context).size.width * 0.82;

    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _bubble(context, fromUser, maxWidth),
          if (!fromUser) _sources(),
        ],
      ),
    );
  }

  /// « Données consultées : État du stock » sous la réponse. En mode debug, on
  /// ajoute le nom technique de la fonction et les temps mesurés.
  Widget _sources() {
    final labels = message.outils.map(assistantToolLabel).join(', ');
    final meta = message.meta;
    final tech =
        kDebugMode
            ? [
              if (message.outils.isNotEmpty) message.outils.join(', '),
              if (meta != null)
                '${formatDuration(meta.totalMs)} (modèle ${formatDuration(meta.modeleMs)}, outils ${formatDuration(meta.outilsMs)}, ${meta.agent}, ${meta.appelsAuModele} appel${meta.appelsAuModele > 1 ? 's' : ''})',
            ].join(' · ')
            : '';
    if (labels.isEmpty && tech.isEmpty && onSpeak == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onSpeak != null) _speakButton(),
          if (labels.isNotEmpty)
            Text(
              "Données consultées : $labels",
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (tech.isNotEmpty)
            Text(
              tech,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }

  /// « Écouter » : lit la réponse à voix haute ; pendant la lecture, devient « Arrêter ».
  Widget _speakButton() {
    return GestureDetector(
      onTap: onSpeak,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSpeaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 5),
            Text(
              isSpeaking ? "Arrêter" : "Écouter",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(BuildContext context, bool fromUser, double maxWidth) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: message.contenu));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Message copié"),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: fromUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(fromUser ? 18 : 4),
            bottomRight: Radius.circular(fromUser ? 4 : 18),
          ),
          border:
              fromUser
                  ? null
                  : Border.all(
                    color: AppColors.primary.withValues(alpha: 0.08),
                  ),
        ),
        child:
            fromUser
                ? Text(
                  message.contenu,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    height: 1.4,
                  ),
                )
                : AssistantRichText(message.contenu),
      ),
    );
  }
}

/// Indicateur « Sika écrit » : trois points qui pulsent.
class AssistantTypingBubble extends StatefulWidget {
  const AssistantTypingBubble({super.key});

  @override
  State<AssistantTypingBubble> createState() => _AssistantTypingBubbleState();
}

class _AssistantTypingBubbleState extends State<AssistantTypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              AppIconsBold.sparkle,
              size: 14,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 8),
            for (var i = 0; i < 3; i++)
              AnimatedBuilder(
                animation: _ctl,
                builder: (_, __) {
                  final t = (_ctl.value - i * 0.18) % 1.0;
                  final opacity = 0.25 + 0.75 * (t < 0.5 ? t * 2 : (1 - t) * 2);
                  return Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: opacity),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
