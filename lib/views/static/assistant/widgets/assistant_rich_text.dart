import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Affiche une réponse de Sika : paragraphes, listes à tirets et **gras**.
/// Volontairement limité à ce que l'assistante produit (pas de Markdown complet).
class AssistantRichText extends StatelessWidget {
  final String text;
  final Color color;

  const AssistantRichText(this.text, {super.key, this.color = AppColors.textDark});

  static final _bullet = RegExp(r'^\s*[-*•]\s+');
  static final _bold = RegExp(r'\*\*(.+?)\*\*');

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(fontSize: 14.5, height: 1.45, color: color);
    final lines = text.trim().split('\n');
    final children = <Widget>[];

    for (final raw in lines) {
      final line = raw.trimRight();
      if (line.trim().isEmpty) {
        children.add(const SizedBox(height: 6));
      } else if (_bullet.hasMatch(line)) {
        children.add(Padding(
          padding: const EdgeInsets.only(top: 2, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7, right: 8),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ),
              Expanded(
                child: Text.rich(_spans(line.replaceFirst(_bullet, ''), base)),
              ),
            ],
          ),
        ));
      } else {
        children.add(Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text.rich(_spans(line, base)),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  static TextSpan _spans(String line, TextStyle base) {
    final spans = <InlineSpan>[];
    var last = 0;
    for (final m in _bold.allMatches(line)) {
      if (m.start > last) spans.add(TextSpan(text: line.substring(last, m.start)));
      spans.add(TextSpan(
        text: m.group(1),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ));
      last = m.end;
    }
    if (last < line.length) spans.add(TextSpan(text: line.substring(last)));
    return TextSpan(style: base, children: spans);
  }
}
