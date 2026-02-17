import 'package:ateliya/api/operateur_api.dart';
import 'package:ateliya/data/models/operateur.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OperatorListPageVctl extends GetxController {
  final api = OperateurApi();
  List<Operateur> operateurs = [];
  bool isLoading = false;

  Future<void> getOperateurs() async {
    isLoading = true;
    update();
    final res = await api.list();
    isLoading = false;
    update();
    if (res.status) {
      operateurs = res.data!.map((e) => Operateur.fromJson(e)).toList();
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  @override
  void onReady() {
    getOperateurs();
    super.onReady();
  }
}
