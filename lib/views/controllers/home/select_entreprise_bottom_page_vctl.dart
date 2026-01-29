import 'package:ateliya/api/entreprise_api.dart';
import 'package:ateliya/data/models/abstract/entite_entreprise.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:get/get.dart';

class SelectEntrepriseBottomPageVctl extends AuthViewController {
  final api = EntrepriseApi();
  bool isLoading = false;

  Future<void> fetchEntrepriseEntities() async {
    isLoading = true;
    update();
    final res = await api.getEntrepriseEntities();
    isLoading = false;
    update();
    if (res.status) {
      entities = res.data!;
      update();
    } else {
      CAlertDialog.show(message: res.message);
    }
  }

  void onSelectEntity(EntiteEntreprise entite) {
    setEntite(entite);
    Get.back(result: entite);
  }

  @override
  void onReady() {
    if (entities.isEmpty) {
      fetchEntrepriseEntities();
    }
    super.onReady();
  }
}
