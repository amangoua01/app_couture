import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class MallModelesVctl extends AuthViewController {
  final _api = MallApi();
  List<MallModeleBoutique> modeles = [];
  List<MallModeleBoutique> modelesArchives = [];

  int tabIndex = 0;
  String searchQuery = '';

  void setTab(int i) {
    tabIndex = i;
    update();
  }

  void setSearch(String v) {
    searchQuery = v;
    update();
  }

  List<MallModeleBoutique> get filtered {
    var list = List<MallModeleBoutique>.from(modeles);
    if (searchQuery.isNotEmpty) {
      list = list
          .where((m) => (m.modele?.libelle ?? '')
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }
    if (tabIndex == 1) {
      list = list.where((m) => m.isNouveaute == true).toList();
    } else if (tabIndex == 2) {
      list = list.where((m) => m.isPromotion == true).toList();
    }
    return list;
  }

  Future<void> loadModeles() async {
    final res = await _api.getMyModeles().load();
    if (res.status) {
      modeles = res.data!.where((m) => m.isActive).toList();
      modelesArchives = res.data!.where((m) => !m.isActive).toList();
      update();
    } else {
      CSnackbar.show(message: res.message ?? 'Erreur inconnue');
    }
  }

  Future<void> reactiverModele(int id) async {
    final res = await _api.updateModeleVisibility(id).load();
    if (res.status) {
      CSnackbar.show(message: 'Modèle réactivé avec succès', isSuccess: true);
      await loadModeles();
    } else {
      CSnackbar.show(message: res.message ?? 'Erreur inconnue');
    }
  }

  @override
  void onReady() {
    loadModeles();
    super.onReady();
  }
}
