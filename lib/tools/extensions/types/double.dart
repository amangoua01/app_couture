import 'package:app_couture/tools/components/functions.dart';
import 'package:app_couture/tools/extensions/types/int.dart';
import 'package:app_couture/tools/extensions/types/string.dart';

extension DoubleExt on double? {
  double get value => this ?? 0.0;
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

  bool get isRealDouble {
    final str = toString();
    if (str.isEmpty) {
      return false;
    } else {
      var parts = [];
      if (str.contains('.')) {
        parts = str.split('.');
      } else if (str.contains(',')) {
        parts = str.split(',');
      }
      if (parts.length > 2) return false;
      if (parts[1].toString().toInt().value > 0) {
        return true;
      } else {
        return false;
      }
    }
  }
}
