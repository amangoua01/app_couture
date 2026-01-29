import 'package:ateliya/api/abonnement_api.dart';
import 'package:ateliya/data/models/abonnement.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:get/get.dart';

class AbonnementsListPageVctl extends GetxController {
  bool isLoading = false;
  List<Abonnement> abonnements = [];
  final api = AbonnementApi();

  Future<void> fetchAbonnements() async {
    isLoading = true;
    update();
    final res = await api.list();
    isLoading = false;
    update();
    if (res.status) {
      abonnements = res.data!;
      update();
    } else {
      CAlertDialog.show(message: res.message);
    }
  }

  @override
  void onReady() {
    fetchAbonnements();
    super.onReady();
  }
}
