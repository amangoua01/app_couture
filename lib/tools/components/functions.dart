import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Functions {
  static Map<String, String> _getMonthLib(DateTime date) {
    var months = [
      {"lite": "Jan.", "full": "Janvier"},
      {"lite": "Fev.", "full": "Février"},
      {"lite": "Mars", "full": "Mars"},
      {"lite": "Avr.", "full": "Avril"},
      {"lite": "Mai", "full": "Mai"},
      {"lite": "Juin", "full": "Juin"},
      {"lite": "Juil.", "full": "Juillet"},
      {"lite": "Août", "full": "Août"},
      {"lite": "Sept.", "full": "Septembre"},
      {"lite": "Oct.", "full": "Octobre"},
      {"lite": "Nov.", "full": "Novembre"},
      {"lite": "Dec.", "full": "Décembre"},
    ];
    var index = date.month - 1;
    return months[index];
  }

  static String getDate(DateTime? date,
      {bool withTime = false,
      String divider = "/",
      String dateTimeDivider = " "}) {
    return (date == null)
        ? ""
        : formatDate(
            date,
            withTime
                ? [dd, divider, mm, divider, yyyy, dateTimeDivider, HH, ":", nn]
                : [dd, divider, mm, divider, yyyy]);
  }

  static String getStringDate(DateTime? date,
      {bool fullMonth = false,
      bool withTime = false,
      String separator = " à "}) {
    var mode = fullMonth ? "full" : "lite";
    if (date != null) {
      var day =
          date.day.toString().length < 2 ? "0${date.day}" : date.day.toString();
      var year = date.year.toString();
      return "$day ${_getMonthLib(date)[mode]!} $year${(withTime) ? separator + getTime(date) : ""}";
    }
    return "";
  }

  static String getTime(DateTime? dateTime) {
    return (dateTime == null) ? "" : formatDate(dateTime, [HH, ':', nn]);
  }

  static Future<bool?> isFirstLaunch() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool("firstLaunch");
  }

  static Future<bool?> setIsFirstLaunch() async {
    var pref = await SharedPreferences.getInstance();
    return pref.setBool("firstLaunch", false);
  }

  static String formatMontant(String? montant,
      {String? devise, int? decimalDigits}) {
    if (montant != null && montant != "null") {
      final NumberFormat format;
      var montantListPart = montant.split(".");
      var nbDecimal = 0;

      if (montantListPart.length > 1 && montantListPart[1].toInt().value > 0) {
        nbDecimal = decimalDigits ?? 2;
      }

      format = NumberFormat.currency(
        locale: 'fr_FR',
        symbol: devise.value,
        decimalDigits: nbDecimal,
      );

      var amount = num.tryParse(montant) ?? 0;
      return format.format(amount).trim();
    } else {
      if (devise != null || devise != "") {
        return "0 $devise";
      }
      return "0";
    }
  }
}
