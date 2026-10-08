import 'package:ateliya/api/caisse_api.dart';
import 'package:ateliya/api/employe_api.dart';
import 'package:ateliya/data/models/caisse.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:intl/intl.dart';

class BilanPaiePageVctl extends AuthViewController {
  final _api = EmployeApi();
  final caisseApi = CaisseApi();
  bool isLoading = true;
  bool isPaying = false;
  List<dynamic> bilans = [];
  DateTime mois = DateTime(DateTime.now().year, DateTime.now().month, 1);

  static const _moisLabels = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre',
  ];

  // Pas de DateFormat(locale) ici : la locale "fr_FR" d'intl n'est pas
  // initialisée dans cette app (voir Functions.getStringDate, même choix).
  String get moisLabel => '${_moisLabels[mois.month - 1]} ${mois.year}';

  DateTime get _debut => mois;
  DateTime get _fin => DateTime(mois.year, mois.month + 1, 0);
  String get _debutStr => DateFormat('yyyy-MM-dd').format(_debut);
  String get _finStr => DateFormat('yyyy-MM-dd').format(_fin);

  @override
  void onReady() {
    super.onReady();
    chargerBilan();
  }

  void moisPrecedent() {
    mois = DateTime(mois.year, mois.month - 1, 1);
    chargerBilan();
  }

  void moisSuivant() {
    final now = DateTime.now();
    final maxMois = DateTime(now.year, now.month, 1);
    final prochain = DateTime(mois.year, mois.month + 1, 1);
    if (prochain.isAfter(maxMois)) return;
    mois = prochain;
    chargerBilan();
  }

  bool get peutAvancer {
    final now = DateTime.now();
    return mois.year < now.year ||
        (mois.year == now.year && mois.month < now.month);
  }

  Future<void> chargerBilan() async {
    isLoading = true;
    update();

    final res = await _api.getBilanPaie(debut: _debutStr, fin: _finStr);
    if (res.status) {
      bilans = res.data ?? [];
    } else {
      CMessageDialog.show(message: res.message);
    }

    isLoading = false;
    update();
  }

  Future<List<Caisse>> getCaisses() async {
    final res = await caisseApi.list();
    return res.status ? res.data!.items : [];
  }

  Future<bool> payer(int employeId, double montant, {int? caisseId}) async {
    isPaying = true;
    update();

    final res = await _api.payer(
      employeId,
      montant,
      caisseId: caisseId,
      debut: _debutStr,
      fin: _finStr,
    );

    isPaying = false;
    update();

    if (res.status) {
      await chargerBilan();
      return true;
    } else {
      CMessageDialog.show(message: res.message);
      return false;
    }
  }
}
