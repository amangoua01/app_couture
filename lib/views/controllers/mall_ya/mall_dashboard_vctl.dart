import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_dashboard_stats.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class MallDashboardVctl extends AuthViewController {
  final _api = MallApi();
  var stats = MallDashboardStats();

  Future<void> loadData() async {
    final res = await _api.getDashboardStats().load();
    if (res.status) {
      stats = res.data!;
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }
}
