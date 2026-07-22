import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_dashboard_stats.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class MallCommandesRecuesVctl extends AuthViewController {
  final _api = MallApi();
  List<MallRecentOrder> _all = [];
  List<MallRecentOrder> commandes = [];
  String? selectedStatut; // null = tous

  static const statuts = [
    (null, 'Tous'),
    ('EN_ATTENTE', 'En attente'),
    ('VALIDEE', 'Validée'),
    ('LIVREE', 'Livrée'),
    ('ANNULEE', 'Annulée'),
  ];

  void setFiltre(String? statut) {
    selectedStatut = statut;
    commandes = statut == null
        ? List.from(_all)
        : _all.where((c) => c.statut == statut).toList();
    update();
  }

  Future<void> invaliderCommande(int commandeId) async {
    final res = await _api.invaliderCommande(commandeId).load();
    if (res.status) {
      CSnackbar.show(
          message: 'Commande invalidée avec succès', isSuccess: true);
      await loadData();
    } else {
      CSnackbar.show(message: res.message);
    }
  }

  Future<void> validerCommande(int commandeId) async {
    final res = await _api.validerCommande(commandeId).load();
    if (res.status) {
      CSnackbar.show(message: 'Commande validée avec succès', isSuccess: true);
      await loadData();
    } else {
      CSnackbar.show(message: res.message);
    }
  }

  Future<void> loadData() async {
    final res = await _api.getCommandesRecues().load();
    if (res.status) {
      _all = res.data!;
      commandes = List.from(_all);
      update();
    } else {
      CSnackbar.show(message: res.message);
    }
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }
}
