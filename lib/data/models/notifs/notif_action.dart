import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotifAction {
  String title;
  String type;
  String value;

  NotifAction({required this.title, required this.type, required this.value});

  void handle() {
    switch (type) {
      case "open_url":
        launchUrlString(value, mode: LaunchMode.externalApplication);
        break;
      case "open_vente_details":
        _handleVenteDetail(value.toInt().value);
        break;
      case "open_commande_details":
        _handleVenteCommande(value.toInt().value);
        break;
      default:
    }
  }

  void _handleVenteDetail(int id) async {
    // final api = VenteApi();
    // final res = await api.getOne(id).load();
    // if (res.status) {
    //   Get.to(() => DetailVentePage(res.data!));
    // } else {
    //   CAlertDialog.show(message: res.message);
    // }
  }

  void _handleVenteCommande(int id) async {
    // final api = CommandeApi();
    // final res = await api.getOne(id).load();
    // if (res.status) {
    //   Get.to(() => DetailCommandePage(res.data!));
    // } else {
    //   CAlertDialog.show(message: res.message);
    // }
  }
}
