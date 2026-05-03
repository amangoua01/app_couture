import 'package:ateliya/api/abonnement_api.dart';
import 'package:ateliya/data/models/abonnement.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:get/get.dart';

class AbonnementsListPageVctl extends GetxController {
  bool isLoading = false;
  Abonnement? abonnementActif;
  int totalAbonnement = 0;
  int nombreAbonnementActif = 0;
  int nombreAbonnementPasse = 0;
  int nombreAbonnementPending = 0;

  final api = AbonnementApi();

  Future<void> fetchAbonnements() async {
    isLoading = true;
    update();
    final res = await api.list();
    isLoading = false;
    if (res.status) {
      final data = res.data!;
      if (data['abonnementActif'] != null) {
        abonnementActif = Abonnement.fromJson(data['abonnementActif']);
      } else {
        abonnementActif = null;
      }

      final kpis = data['kpis'] ?? {};
      totalAbonnement = kpis['totalAbonnement'] ?? 0;
      nombreAbonnementActif = kpis['nombreAbonnementActif'] ?? 0;
      nombreAbonnementPasse = kpis['nombreAbonnementPasse'] ?? 0;
      nombreAbonnementPending = kpis['nombreAbonnementPending'] ?? 0;

      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  @override
  void onReady() {
    fetchAbonnements();
    super.onReady();
  }
}
