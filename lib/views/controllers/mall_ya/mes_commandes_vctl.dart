import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_dashboard_stats.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class MesCommandesVctl extends AuthViewController {
  final _api = MallApi();
  List<MallRecentOrder> commandes = [];
  bool loading = true;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    loading = true;
    update();
    final res = await _api.getUserCommandes(user.id!).load();
    if (res.status) {
      commandes = res.data!;
    } else {
      CSnackbar.show(message: res.message);
    }
    loading = false;
    update();
  }
}
