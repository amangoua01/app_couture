/// Montant en XOF avec espace entre les milliers : 125000 -> "125 000 XOF".
String formatXof(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }
  return '${value < 0 ? '-' : ''}$buffer XOF';
}

String formatDate(DateTime date) {
  final d = date.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.day)}/${two(d.month)}/${d.year}';
}

/// « 23/11/2026 à 14:54 ».
String formatDateTime(DateTime date) {
  final d = date.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${formatDate(d)} à ${two(d.hour)}:${two(d.minute)}';
}
