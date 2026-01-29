import 'package:ateliya/api/boutique_api.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class BoutiquePageVctl extends AuthViewController {
  bool isGridView = true;
  bool isLoading = false;
  bool isSearching = false;
  List<ModeleBoutique> data = [];
  final api = BoutiqueApi();

  Future<void> fetchData() async {
    if (getEntite().value.isNotEmpty) {
      isLoading = true;
      update();
      final res = await api.getModeleBoutiqueByBoutiqueId(
        getEntite().value.id.value,
      );
      isLoading = false;
      update();
      if (res.status) {
        data = res.data!;
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }

  @override
  void onReady() {
    fetchData();
    super.onReady();
  }
}
