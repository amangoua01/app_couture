import 'package:ateliya/api/accueil_api.dart';
import 'package:ateliya/data/models/accueil_data.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class HomePageVctl extends AuthViewController {
  var data = AccueilData();
  final api = AccueilApi();

  Future<void> loadData() async {
    if (getEntite().value.isNotEmpty) {
      final res = await api
          .getAccueilData(getEntite().value.id!, getEntite().value.type)
          .load();
      if (res.status) {
        data = res.data!;
        update();
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }
}
