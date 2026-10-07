import 'package:ateliya/api/operateur_api.dart';
import 'package:ateliya/data/models/operateur.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OperatorListPageVctl extends GetxController {
  final api = OperateurApi();
  static List<Operateur>? _cachedOperateurs;
  List<Operateur> operateurs = _cachedOperateurs ?? [];
  bool isLoading = _cachedOperateurs == null;

  /// Précharge en arrière-plan les opérateurs pour une ouverture instantanée
  static Future<void> prefetch() async {
    if (_cachedOperateurs != null && _cachedOperateurs!.isNotEmpty) return;
    try {
      final res = await OperateurApi().list();
      if (res.status) {
        _cachedOperateurs =
            res.data!.map((e) => Operateur.fromJson(e)).toList();
      }
    } catch (_) {}
  }

  Future<void> getOperateurs() async {
    if (operateurs.isEmpty) {
      isLoading = true;
      update();
    }
    final res = await api.list();
    isLoading = false;
    if (res.status) {
      operateurs = res.data!.map((e) => Operateur.fromJson(e)).toList();
      _cachedOperateurs = operateurs;
    } else if (operateurs.isEmpty) {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  @override
  void onReady() {
    getOperateurs();
    super.onReady();
  }
}
