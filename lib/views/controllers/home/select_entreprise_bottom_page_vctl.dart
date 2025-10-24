import 'package:app_couture/api/entreprise_api.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/views/controllers/abstract/auth_view_controller.dart';

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

  @override
  void onReady() {
    if (entities.isEmpty) {
      fetchEntrepriseEntities();
    }
    super.onReady();
  }
}
