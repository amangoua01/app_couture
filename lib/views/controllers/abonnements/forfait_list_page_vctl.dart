import 'package:ateliya/api/abonnement_api.dart';
import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ForfaitListPageVctl extends GetxController {
  final api = AbonnementApi();
  List<ModuleAbonnement> forfaits = [];
  bool isLoading = false;

  Future<void> getForfaits() async {
    isLoading = true;
    update();
    final res = await api.listForfaire();
    isLoading = false;
    update();
    if (res.status) {
      forfaits = res.data!;
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  @override
  void onReady() {
    getForfaits();
    super.onReady();
  }
}
