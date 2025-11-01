import 'package:app_couture/api/categorie_mesure_api.dart';
import 'package:app_couture/api/categorie_type_mesure_api.dart';
import 'package:app_couture/data/models/categorie_mesure.dart';
import 'package:app_couture/data/models/categorie_type_mesure.dart';
import 'package:app_couture/data/models/type_mesure.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:get/get.dart';

class CategorieTypeMesureListVctl extends GetxController {
  final TypeMesure typeMesure;
  final categorieApi = CategorieMesureApi();
  bool isLoading = false;

  final categorieTypeMesureApi = CategorieTypeMesureApi();
  List<CategorieMesure> categories = [];
  List<CategorieTypeMesure> categoriesType = [];
  List<CategorieTypeMesure> added = [];
  List<CategorieTypeMesure> deleted = [];

  CategorieTypeMesureListVctl(this.typeMesure);

  Future<void> getCategories() async {
    isLoading = true;
    update();
    final res = await categorieApi.list();
    isLoading = false;
    update();
    if (res.status) {
      categories = res.data!.items;
      update();
    } else {
      CAlertDialog.show(message: res.message);
    }
  }

  Future<void> getList() async {
    isLoading = true;
    update();
    final res = await categorieTypeMesureApi.list(id: typeMesure.id);
    isLoading = false;
    update();
    if (res.status) {
      categoriesType = res.data!.items;
      update();
    } else {
      CAlertDialog.show(message: res.message);
    }
  }

  bool isSelected(int categorieId) {
    var isPresent = categoriesType
        .where((element) => element.categorieMesure?.id == categorieId)
        .isNotEmpty;
    if (!isPresent) {
      isPresent = added
          .where((element) => element.categorieMesure?.id == categorieId)
          .isNotEmpty;
    }
    return isPresent;
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }

  Future<void> loadData() async {
    await getCategories();
    await getList();
  }
}
