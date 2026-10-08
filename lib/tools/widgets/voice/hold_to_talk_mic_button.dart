import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Bouton micro à appui maintenu avec verrouillage par glissement, façon
/// "slide to unlock" : un appui bref écoute tant que le doigt reste posé,
/// mais le simple fait de poser le doigt fait apparaître une piste de
/// glissement explicite (pastille + flèches + cadenas cible) — pas besoin
/// d'explication, le geste se devine comme sur un verrouillage d'écran.
/// En glissant la pastille jusqu'au cadenas, l'écoute se verrouille et
/// continue mains libres — utile quand l'utilisateur doit, par exemple,
/// prendre une mesure au ruban entre deux phrases dictées. Le
/// verrouillage se referme via le bouton "Valider" (ou "Annuler" pour
/// tout effacer).
///
/// Ce widget ne gère que le geste et l'affichage : le démarrage/arrêt
/// réel de la reconnaissance vocale et l'accumulation du texte restent à
/// la charge de l'écran appelant, via les callbacks.
class HoldToTalkMicButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onHoldStart;
  final VoidCallback onHoldRelease;
  final VoidCallback onLock;
  final VoidCallback onValidate;
  final VoidCallback onCancel;

  /// Vrai quand le moteur s'est arrêté tout seul (silence prolongé) alors
  /// qu'on est verrouillé : plutôt que de redémarrer automatiquement (source
  /// de pertes de texte difficiles à fiabiliser avec ce plugin — deux
  /// chemins d'arrêt possibles, 'done'/'notListening' ET des erreurs comme
  /// 'error_speech_timeout', avec des risques de double déclenchement), on
  /// affiche un bouton "Reprendre" explicite.
  final bool isPaused;
  final VoidCallback onResume;

  const HoldToTalkMicButton({
    super.key,
    required this.isListening,
    required this.onHoldStart,
    required this.onHoldRelease,
    required this.onLock,
    required this.onValidate,
    required this.onCancel,
    this.isPaused = false,
    required this.onResume,
  });

  @override
  State<HoldToTalkMicButton> createState() => _HoldToTalkMicButtonState();
}

class _HoldToTalkMicButtonState extends State<HoldToTalkMicButton> {
  static const double _maxTrackWidth = 224;
  static const double _trackHeight = 44;
  static const double _thumbSize = 36;
  static const double _thumbInset = 4;

  bool _held = false;
  bool _locked = false;
  double _dragDx = 0;

  // Mis à jour à chaque build par le LayoutBuilder : le seuil de
  // verrouillage doit se baser sur la largeur réellement disponible, pas
  // sur une largeur fixe qui peut dépasser l'espace réel selon l'écran —
  // sinon le pouce peut glisser au-delà des bords de la piste (débordement
  // observé pendant le glissement).
  double _trackWidth = _maxTrackWidth;
  double get _lockThreshold => _trackWidth - _thumbSize - _thumbInset * 2 - 6;

  void _onPanStart(DragStartDetails d) {
    if (_locked) return;
    setState(() {
      _held = true;
      _dragDx = 0;
    });
    widget.onHoldStart();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_locked || !_held) return;
    final threshold = _lockThreshold;
    setState(() {
      _dragDx = (_dragDx + d.delta.dx).clamp(0, threshold);
    });
    if (_dragDx >= threshold) {
      setState(() {
        _locked = true;
        _held = false;
        _dragDx = 0;
      });
      widget.onLock();
    }
  }

  void _onPanEnd(DragEndDetails d) {
    if (_locked) return;
    final wasHeld = _held;
    setState(() {
      _held = false;
      _dragDx = 0;
    });
    if (wasHeld) widget.onHoldRelease();
  }

  void _onPanCancel() {
    if (_locked || !_held) return;
    setState(() {
      _held = false;
      _dragDx = 0;
    });
    widget.onHoldRelease();
  }

  void _validate() {
    setState(() => _locked = false);
    widget.onValidate();
  }

  void _cancel() {
    setState(() => _locked = false);
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_locked) return _buildLockedBar();

    // LayoutBuilder borne la largeur réellement disponible (le Row parent
    // ne contraint pas lui-même un enfant non-flexible, d'où le
    // débordement observé sans ça) : la piste s'adapte à cet espace plutôt
    // que d'imposer une largeur fixe qui peut dépasser l'écran selon
    // l'appareil ou l'échelle de police système.
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite ? constraints.maxWidth : _maxTrackWidth;
        // Capturé pour être réutilisé par les gestionnaires de glissement
        // (_onPanUpdate n'a pas accès aux contraintes de layout).
        _trackWidth = _maxTrackWidth > available ? available : _maxTrackWidth;

        return GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          onPanCancel: _onPanCancel,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.centerRight,
            child: _held
                ? SizedBox(
                    width: _trackWidth,
                    height: _trackHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(_trackHeight / 2),
                        border: Border.all(color: const Color(0xFFDC2626).withValues(alpha: 0.25)),
                      ),
                      child: _buildTrack(),
                    ),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: available),
                    child: _buildIdlePill(),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildIdlePill() {
    return Container(
      height: _trackHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(_trackHeight / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mic_none_rounded, color: Colors.white, size: 18),
          const Gap(6),
          const Flexible(
            child: Text(
              "Maintenir pour parler",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const Gap(4),
          // Dès le repos, un indice visuel qu'on peut glisser vers la
          // droite — sans attendre que l'utilisateur appuie pour le
          // découvrir.
          const _ChevronHint(color: Colors.white70, size: 13),
        ],
      ),
    );
  }

  Widget _buildTrack() {
    final fade = (1 - _dragDx / _lockThreshold).clamp(0.0, 1.0);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Repère "cadenas" : la cible vers laquelle on glisse.
        Positioned(
          right: 12,
          child: Icon(
            Icons.lock_outline_rounded,
            size: 18,
            color: const Color(0xFFDC2626).withValues(alpha: 0.4 + 0.6 * (1 - fade)),
          ),
        ),
        // Indice de direction : chevrons + texte, qui s'estompent à mesure
        // que le pouce s'approche du cadenas. Texte court et protégé par
        // Flexible/ellipsis : à grande échelle de police système (ex.
        // MIUI), une phrase plus longue ici débordait de cet espace
        // volontairement étroit.
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(left: _thumbSize + _thumbInset * 2, right: 36),
            child: Opacity(
              opacity: fade,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Glisser",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFDC2626).withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const Gap(3),
                  const _ChevronHint(),
                ],
              ),
            ),
          ),
        ),
        // Pastille micro, glissée vers la droite par le doigt.
        Positioned(
          left: _thumbInset + _dragDx,
          child: Container(
            width: _thumbSize,
            height: _thumbSize,
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x33DC2626), blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: const Icon(Icons.mic, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(color: Color(0x33DC2626), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isPaused)
            Flexible(
              child: InkWell(
                onTap: widget.onResume,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.mic_rounded, color: Colors.white, size: 17),
                      const Gap(6),
                      const Flexible(
                        child: Text(
                          "Reprendre",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            const _PulsingDot(),
            const Gap(8),
            const Flexible(
              child: Text(
                "Verrouillé",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          const Gap(10),
          Container(width: 1, height: 22, color: Colors.white.withValues(alpha: 0.25)),
          const Gap(6),
          // Zones de clic généreuses et nettement séparées : trop petites
          // et trop proches l'une de l'autre, "Annuler" ratait souvent et
          // touchait "Valider" à la place.
          _LockedActionButton(
            icon: Icons.delete_outline_rounded,
            background: Colors.white.withValues(alpha: 0.18),
            iconColor: Colors.white,
            onTap: _cancel,
            tooltip: "Annuler",
          ),
          const Gap(4),
          _LockedActionButton(
            icon: Icons.check_rounded,
            background: Colors.white,
            iconColor: const Color(0xFFDC2626),
            onTap: _validate,
            tooltip: "Valider",
          ),
        ],
      ),
    );
  }
}

/// Bouton d'action de la barre verrouillée : zone de clic de 36×36 (au
/// lieu des ~26px d'avant, trop proches l'une de l'autre et sources de
/// clics ratés) avec un vrai retour visuel (ripple) au toucher.
class _LockedActionButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onTap;
  final String tooltip;

  const _LockedActionButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Center(child: Icon(icon, color: iconColor, size: 18)),
          ),
        ),
      ),
    );
  }
}

/// Deux chevrons qui pulsent doucement l'un après l'autre, pour que l'œil
/// comprenne "glisser vers la droite" sans avoir à lire le texte.
class _ChevronHint extends StatefulWidget {
  final Color color;
  final double size;

  const _ChevronHint({this.color = const Color(0xFFDC2626), this.size = 15});

  @override
  State<_ChevronHint> createState() => _ChevronHintState();
}

class _ChevronHintState extends State<_ChevronHint> with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctl,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(2, (i) {
            final phase = (_ctl.value - i * 0.25) % 1.0;
            final opacity = (phase < 0.5 ? phase * 2 : (1 - phase) * 2).clamp(0.25, 1.0);
            return Opacity(
              opacity: opacity,
              child: Icon(Icons.chevron_right_rounded, size: widget.size, color: widget.color),
            );
          }),
        );
      },
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.3, end: 1.0).animate(_ctl),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      ),
    );
  }
}
