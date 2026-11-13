import 'package:ateliya/tools/extensions/types/int.dart';

/// Montant compact pour les axes et les petites puces : 12 500 -> « 12,5 k ».
String compactAmount(num value) {
  final v = value.abs();
  String text;
  if (v >= 1000000000) {
    text = '${_trim(v / 1000000000)} Md';
  } else if (v >= 1000000) {
    text = '${_trim(v / 1000000)} M';
  } else if (v >= 1000) {
    text = '${_trim(v / 1000)} k';
  } else {
    text = v.round().toString();
  }
  return value < 0 ? '-$text' : text;
}

String _trim(double d) {
  final text = d >= 100 ? d.round().toString() : d.toStringAsFixed(1);
  return (text.endsWith('.0') ? text.substring(0, text.length - 2) : text)
      .replaceAll('.', ',');
}

/// Montant complet : 12500 -> « 12 500 F ».
String francs(num value) => value.round().toAmount(unit: 'F');

/// Pourcentage de [part] dans [total], sans décimale.
String sharePercent(num part, num total) =>
    total <= 0 ? '0 %' : '${(part / total * 100).round()} %';
