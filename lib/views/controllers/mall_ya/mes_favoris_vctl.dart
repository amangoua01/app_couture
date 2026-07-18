import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_favori.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class MesFavorisVctl extends AuthViewController {
  final _api = MallApi();
  List<MallFavori> favoris = [];
  bool loading = true;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    loading = true;
    update();
    final res = await _api.getFavorisDetails(user.id!).load();
    if (res.status) favoris = res.data!;
    loading = false;
    update();
  }

  Future<void> retirer(MallFavori favori) async {
    final modeleBoutiqueId = favori.modeleBoutique?.id;
    if (modeleBoutiqueId == null) return;
    final res = await _api.toggleFavori(modeleBoutiqueId, user.id!).load();
    if (res.status) {
      favoris.remove(favori);
      update();
      CSnackbar.show(message: 'Retiré des favoris', isSuccess: true);
    } else {
      CSnackbar.show(message: res.message);
    }
  }
}
