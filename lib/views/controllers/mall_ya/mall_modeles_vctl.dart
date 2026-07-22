import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class MallModelesVctl extends AuthViewController {
  final _api = MallApi();
  List<MallModeleBoutique> modeles = [];
  List<MallModeleBoutique> modelesArchives = [];
  List<MallModeleBoutique> promotions = [];
  List<MallModeleBoutique> nouveautes = [];

  bool loading = false;
  int tabIndex = 0;
  String searchQuery = '';
  int? selectedBoutiqueId;

  List<MallBoutiqueInfo> get boutiqueOptions {
    final source = tabIndex == 1
        ? nouveautes
        : tabIndex == 2
            ? promotions
            : modeles;
    final seen = <int>{};
    return source
        .where((m) => m.boutique != null && seen.add(m.boutique!.id))
        .map((m) => m.boutique!)
        .toList();
  }

  void setBoutique(int? id) {
    selectedBoutiqueId = id;
    update();
  }

  void setTab(int i) {
    tabIndex = i;
    searchQuery = '';
    selectedBoutiqueId = null;
    update();
    if (i == 1 && nouveautes.isEmpty) _loadNouveautes();
    if (i == 2 && promotions.isEmpty) _loadPromotions();
  }

  void setSearch(String v) {
    searchQuery = v;
    update();
  }

  List<MallModeleBoutique> get filtered {
    final source = tabIndex == 1
        ? nouveautes
        : tabIndex == 2
            ? promotions
            : modeles;
    var list = source;
    if (selectedBoutiqueId != null) {
      list = list.where((m) => m.boutique?.id == selectedBoutiqueId).toList();
    }
    if (searchQuery.isEmpty) return list;
    return list
        .where((m) => (m.modele?.libelle ?? '')
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
  }

  String? get _codeMarchand => user.entreprise?.codeMarchand;

  Future<void> loadModeles() async {
    loading = true;
    update();
    final res = await _api.getMyModeles().load();
    if (res.status) {
      modeles = res.data!.where((m) => m.isActive).toList();
      modelesArchives = res.data!.where((m) => !m.isActive).toList();
    } else {
      CSnackbar.show(message: res.message ?? 'Erreur inconnue');
    }
    loading = false;
    update();
  }

  Future<void> _loadNouveautes() async {
    final code = _codeMarchand;
    if (code == null || code.isEmpty) return;
    loading = true;
    update();
    final res = await _api.getNouveautes(code).load();
    if (res.status) {
      nouveautes = res.data!;
    } else {
      CSnackbar.show(message: res.message ?? 'Erreur inconnue');
    }
    loading = false;
    update();
  }

  Future<void> _loadPromotions() async {
    final code = _codeMarchand;
    if (code == null || code.isEmpty) return;
    loading = true;
    update();
    final res = await _api.getPromotions(code).load();
    if (res.status) {
      promotions = res.data!;
    } else {
      CSnackbar.show(message: res.message ?? 'Erreur inconnue');
    }
    loading = false;
    update();
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
