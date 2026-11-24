import 'package:ateliya/data/models/assistant/assistant_message.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/views/static/assistant/assistant_tool_labels.dart';
import 'package:ateliya/views/static/assistant/widgets/assistant_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bulle d'un message : à droite (vert) pour l'utilisateur, à gauche (blanche) pour Sika.
class AssistantBubble extends StatelessWidget {
  final AssistantMessage message;

  /// Vrai pendant que cette réponse est lue à voix haute.
  final bool isSpeaking;

  /// Touche « Écouter » / « Arrêter » ; null masque le bouton.
  final VoidCallback? onSpeak;

  /// Ouvre le choix de la voix (voix, vitesse, ton) ; null masque le bouton.
  final VoidCallback? onVoiceSettings;

  /// Message tout juste arrivé : il apparaît en fondu, et la réponse de Sika s'écrit progressivement.
  final bool animate;

  /// Appelé pendant que la réponse s'écrit, pour garder la fin du fil visible.
  final VoidCallback? onGrow;

  const AssistantBubble(
    this.message, {
    super.key,
    this.isSpeaking = false,
    this.onSpeak,
    this.onVoiceSettings,
    this.animate = false,
    this.onGrow,
  });

  @override
  Widget build(BuildContext context) {
    final fromUser = message.fromUser;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.82;

    final content = Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _bubble(context, fromUser, maxWidth),
          if (!fromUser) _sources(context),
        ],
      ),
    );
    return RepaintBoundary(
      child: animate ? AssistantEntrance(fromUser: fromUser, child: content) : content,
    );
  }

  /// « Données consultées : État du stock » sous la réponse. En mode debug, on
  /// ajoute le nom technique de la fonction et les temps mesurés.
  Widget _sources(BuildContext context) {
    final labels = message.outils.map(assistantToolLabel).join(', ');
    if (labels.isEmpty && onSpeak == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onSpeak != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _speakButton(),
                if (onVoiceSettings != null) _voiceSettingsButton(),
                _copyButton(context),
              ],
            ),
          if (labels.isNotEmpty)
            Text(
              "Données consultées : $labels",
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
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

  /// Petite icône réglages à côté de « Écouter » : choix de la voix.
  Widget _voiceSettingsButton() {
    return GestureDetector(
      onTap: onVoiceSettings,
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        padding: EdgeInsets.only(left: 14, top: 4, bottom: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune_rounded, size: 16, color: AppColors.textMuted),
            SizedBox(width: 4),
            Text("Voix", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  void _copy(BuildContext context) {
    // Texte propre : sans les ** du gras.
    Clipboard.setData(ClipboardData(text: message.contenu.replaceAll('**', '')));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text("Réponse copiée"),
          duration: Duration(seconds: 1),
        ),
      );
  }

  /// « Copier » : met la réponse dans le presse-papiers.
  Widget _copyButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _copy(context),
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        padding: EdgeInsets.only(left: 14, top: 4, bottom: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.copy_rounded, size: 16, color: AppColors.textMuted),
            SizedBox(width: 4),
            Text("Copier", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _bubble(BuildContext context, bool fromUser, double maxWidth) {
    return GestureDetector(
      onLongPress: () => _copy(context),
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
                : (animate
                    ? AssistantTypewriter(message.contenu, onGrow: onGrow)
                    : AssistantRichText(message.contenu)),
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
    return AssistantEntrance(
      fromUser: false,
      child: Align(
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
      ),
    );
  }
}


/// Apparition d'un message : fondu + léger glissement vers le haut (joué une seule fois).
class AssistantEntrance extends StatelessWidget {
  final Widget child;
  final bool fromUser;

  const AssistantEntrance({super.key, required this.child, required this.fromUser});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (_, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(fromUser ? 14 * (1 - t) : -14 * (1 - t), 14 * (1 - t)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

/// Écrit la réponse de Sika progressivement (effet « machine à écrire »), mot par mot.
class AssistantTypewriter extends StatefulWidget {
  final String text;
  final VoidCallback? onGrow;

  const AssistantTypewriter(this.text, {super.key, this.onGrow});

  @override
  State<AssistantTypewriter> createState() => _AssistantTypewriterState();
}

class _AssistantTypewriterState extends State<AssistantTypewriter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;
  late final List<int> _ends; // fin de chaque mot (indice dans le texte)
  int _shown = 0;

  @override
  void initState() {
    super.initState();
    _ends = [for (final m in RegExp(r'\S+').allMatches(widget.text)) m.end];
    // ~35 ms par mot, entre 0,6 s et 3 s : assez pour sentir l'écriture sans faire attendre.
    final ms = (_ends.length * 35).clamp(600, 3000);
    _ctl = AnimationController(vsync: this, duration: Duration(milliseconds: ms))
      ..addListener(_tick)
      ..forward();
  }

  void _tick() {
    final n = (_ctl.value * _ends.length).ceil().clamp(0, _ends.length);
    if (n != _shown) {
      setState(() => _shown = n);
      widget.onGrow?.call();
    }
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ends.isEmpty || _shown >= _ends.length) {
      return AssistantRichText(widget.text);
    }
    var partial = widget.text.substring(0, _ends[(_shown - 1).clamp(0, _ends.length - 1)]);
    // Un gras encore ouvert s'afficherait avec ses étoiles : on le referme.
    if ('**'.allMatches(partial).length.isOdd) partial += '**';
    return AssistantRichText(partial);
  }
}
