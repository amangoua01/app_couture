import 'package:ateliya/api/abonnement_api.dart';
import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abonnements/operator_list_page_vctl.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ForfaitListPageVctl extends GetxController {
  final api = AbonnementApi();
  static List<ModuleAbonnement>? _cachedForfaits;
  List<ModuleAbonnement> forfaits = _cachedForfaits ?? [];
  bool isLoading = _cachedForfaits == null;

  Future<void> getForfaits() async {
    if (forfaits.isEmpty) {
      isLoading = true;
      update();
    }
    final res = await api.listForfaire();
    isLoading = false;
    if (res.status) {
      forfaits = res.data!;
      _cachedForfaits = forfaits;
    } else if (forfaits.isEmpty) {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  @override
  void onReady() {
    getForfaits();
    // Précharge silencieusement les opérateurs pour que l'étape suivante soit instantanée
    OperatorListPageVctl.prefetch();
    super.onReady();
  }
}
