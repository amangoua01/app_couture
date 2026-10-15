import 'package:flutter/material.dart';

/// Événements saisonniers affichés sur le logo Ateliya.
///
/// Ajouter une fête = ajouter une entrée dans [SeasonalEvent.all] (dates,
/// couleurs) et, si besoin, son visuel dans [_SeasonalIcon]. Le choix de la
/// fête du jour est automatique, d'après la date du téléphone.
enum SeasonalKey { octobreRose, noel, nouvelAn, saintValentin }

class SeasonalEvent {
  final SeasonalKey key;
  final String label;

  /// Vrai à la date donnée (mois 1-12, jour 1-31).
  final bool Function(int month, int day) active;

  /// Fond, texte et dégradé du cadre autour du logo.
  final Color tint;
  final Color textColor;
  final List<Color> frame;

  const SeasonalEvent({
    required this.key,
    required this.label,
    required this.active,
    required this.tint,
    required this.textColor,
    required this.frame,
  });

  static final all = <SeasonalEvent>[
    SeasonalEvent(
      key: SeasonalKey.octobreRose,
      label: "Octobre rose",
      active: (m, d) => m == 10,
      tint: const Color(0xFFFDF2F8),
      textColor: const Color(0xFFBE185D),
      frame: const [Color(0xFFF9A8D4), Color(0xFFFCE7F3), Color(0xFFF472B6)],
    ),
    SeasonalEvent(
      key: SeasonalKey.noel,
      label: "Joyeux Noël",
      active: (m, d) => m == 12 && d <= 26,
      tint: const Color(0xFFFEF2F2),
      textColor: const Color(0xFFB91C1C),
      frame: const [Color(0xFFF87171), Color(0xFFD1FAE5), Color(0xFF10B981)],
    ),
    SeasonalEvent(
      key: SeasonalKey.nouvelAn,
      label: "Bonne année",
      active: (m, d) => (m == 12 && d >= 27) || (m == 1 && d <= 7),
      tint: const Color(0xFFFFFBEB),
      textColor: const Color(0xFFB45309),
      frame: const [Color(0xFFFCD34D), Color(0xFFFEF9C3), Color(0xFFF59E0B)],
    ),
    SeasonalEvent(
      key: SeasonalKey.saintValentin,
      label: "Saint-Valentin",
      active: (m, d) => m == 2 && d <= 14,
      tint: const Color(0xFFFFF1F2),
      textColor: const Color(0xFFBE123C),
      frame: const [Color(0xFFFDA4AF), Color(0xFFFFE4E6), Color(0xFFF43F5E)],
    ),
  ];

  /// Fête en cours à la date donnée (aujourd'hui par défaut), sinon `null`.
  static SeasonalEvent? current([DateTime? now]) {
    final date = now ?? DateTime.now();
    for (final e in all) {
      if (e.active(date.month, date.day)) return e;
    }
    return null;
  }
}

/// Logo dans une carte blanche bien encadrée, avec le visuel de la fête posé
/// sur un angle et sa légende dessous. Sans fête : simple carte blanche.
class SeasonalLogoFrame extends StatelessWidget {
  final Widget child;
  final SeasonalEvent? event;

  /// Côté de la carte, pour qu'elle coïncide exactement avec l'écran natif
  /// de démarrage. Sans valeur, la carte épouse son contenu.
  final double? size;

  SeasonalLogoFrame({
    required this.child,
    SeasonalEvent? event,
    this.size,
    super.key,
  }) : event = event ?? SeasonalEvent.current();

  @override
  Widget build(BuildContext context) {
    final ev = event;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient:
                ev == null
                    ? null
                    : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: ev.frame,
                    ),
            color: ev == null ? Colors.white : null,
            border:
                ev == null ? Border.all(color: const Color(0xFFD9E2DC)) : null,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF243329).withValues(alpha: 0.25),
                blurRadius: 30,
                offset: const Offset(0, 14),
                spreadRadius: -12,
              ),
            ],
          ),
          child: Container(
            width: size == null ? null : size! - 6,
            height: size == null ? null : size! - 6,
            alignment: Alignment.center,
            padding:
                size == null
                    ? const EdgeInsets.symmetric(horizontal: 28, vertical: 22)
                    : null,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: child,
          ),
        ),
        if (ev != null) ...[
          if (ev.key == SeasonalKey.noel)
            Positioned(
              left: -14,
              top: -22,
              child: Transform.rotate(
                angle: -0.31,
                child: const SizedBox(
                  width: 62,
                  height: 50,
                  child: _SeasonalIcon(SeasonalKey.noel),
                ),
              ),
            )
          else
            Positioned(
              right: -12,
              top: -14,
              child: Container(
                width: 46,
                height: 46,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _SeasonalIcon(ev.key),
              ),
            ),
        ],
      ],
    );
  }
}

/// Visuel de la fête posé sur le coin d'un logo (sans cadre), pour les
/// endroits où le logo reste affiché tel quel. À placer dans un `Stack`.
class SeasonalLogoMark extends StatelessWidget {
  final double size;

  const SeasonalLogoMark({this.size = 26, super.key});

  @override
  Widget build(BuildContext context) {
    final ev = SeasonalEvent.current();
    if (ev == null) return const SizedBox.shrink();
    if (ev.key == SeasonalKey.noel) {
      return Transform.rotate(
        angle: -0.31,
        child: SizedBox(
          width: size * 1.3,
          height: size,
          child: const _SeasonalIcon(SeasonalKey.noel),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _SeasonalIcon(ev.key),
    );
  }
}

class _SeasonalIcon extends StatelessWidget {
  final SeasonalKey kind;

  const _SeasonalIcon(this.kind);

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case SeasonalKey.octobreRose:
        return CustomPaint(painter: _RibbonPainter());
      case SeasonalKey.noel:
        return CustomPaint(painter: _SantaHatPainter());
      case SeasonalKey.nouvelAn:
        return const FittedBox(
          child: Icon(Icons.auto_awesome, color: Color(0xFFF59E0B)),
        );
      case SeasonalKey.saintValentin:
        return const FittedBox(
          child: Icon(Icons.favorite, color: Color(0xFFF43F5E)),
        );
    }
  }
}

/// Ruban rose de la lutte contre le cancer du sein.
class _RibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    canvas.save();
    canvas.scale(s, size.height / 24);

    final leg =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.2
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(12, 12.2),
      const Offset(7, 22.2),
      leg..color = const Color(0xFFDB2777),
    );
    canvas.drawLine(
      const Offset(12, 12.2),
      const Offset(17, 22.2),
      leg..color = const Color(0xFFEC4899),
    );

    final loop =
        Path()
          ..moveTo(12, 12.6)
          ..cubicTo(6.2, 8.4, 7.4, 2, 12, 2)
          ..cubicTo(16.6, 2, 17.8, 8.4, 12, 12.6)
          ..close();
    final hole =
        Path()
          ..moveTo(12, 9.7)
          ..cubicTo(14.4, 7.5, 14.2, 4.7, 12, 4.7)
          ..cubicTo(9.8, 4.7, 9.6, 7.5, 12, 9.7)
          ..close();
    canvas.drawPath(
      Path.combine(PathOperation.difference, loop, hole),
      Paint()..color = const Color(0xFFEC4899),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bonnet de Père Noël.
class _SantaHatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 32, size.height / 26);

    final body =
        Path()
          ..moveTo(4, 20)
          ..cubicTo(6, 7, 17, 2, 25.5, 9)
          ..cubicTo(21.5, 8.4, 19.5, 12.4, 21.3, 20)
          ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFFDC2626));

    final light =
        Path()
          ..moveTo(4, 20)
          ..cubicTo(6, 12, 11, 7.5, 17, 6.2)
          ..cubicTo(10, 9, 7.5, 14, 7.5, 20)
          ..close();
    canvas.drawPath(
      light,
      Paint()..color = const Color(0xFFEF4444).withValues(alpha: 0.8),
    );

    final white = Paint()..color = Colors.white;
    final shadow =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6;
    final brim = RRect.fromRectAndRadius(
      const Rect.fromLTWH(1.5, 18, 24, 6),
      const Radius.circular(3),
    );
    canvas.drawRRect(brim, white);
    canvas.drawRRect(brim, shadow);
    canvas.drawCircle(const Offset(27, 9), 3.6, white);
    canvas.drawCircle(const Offset(27, 9), 3.6, shadow);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
