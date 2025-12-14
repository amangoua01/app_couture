import 'package:ateliya/tools/components/functions.dart';

extension IntExt on int? {
  int get value => this ?? 0;
  String toAmount({
    String? unit,
    int? decimalDigits,
  }) {
    return Functions.formatMontant(
      toString(),
      devise: unit,
      decimalDigits: decimalDigits,
    );
  }

  bool toBool() => this == 1;
}
