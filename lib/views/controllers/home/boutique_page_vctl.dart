import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class BoutiquePageVctl extends GetxController {
  bool isGridView = true;
  bool isLoading = false;
  bool isSearching = false;
  List<ModeleBoutique> data = [];
  final api = BoutiqueApi();

  Future<void> fetchData() async {
    isLoading = true;
    update();
    final res = await api.getModeleBoutiqueByBoutiqueId(1);
    isLoading = false;
    update();
    if (res.status) {
      data = res.data!;
    } else {
      CAlertDialog.show(message: res.message);
    }
  }

  @override
  void onReady() {
    fetchData();
    super.onReady();
  }
}
