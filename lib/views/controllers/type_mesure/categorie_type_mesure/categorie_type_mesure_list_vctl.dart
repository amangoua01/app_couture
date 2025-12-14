import 'package:ateliya/api/categorie_mesure_api.dart';
import 'package:ateliya/api/categorie_type_mesure_api.dart';
import 'package:ateliya/data/dto/create_categorie_type_mesure_dto.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';
import 'package:ateliya/data/models/categorie_type_mesure.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:get/get.dart';

class CategorieTypeMesureListVctl extends GetxController {
  final TypeMesure typeMesure;
  final categorieApi = CategorieMesureApi();
  bool isLoading = false;

  final categorieTypeMesureApi = CategorieTypeMesureApi();
  List<CategorieMesure> categories = [];
  List<CategorieTypeMesure> categoriesType = [];

  CategorieTypeMesureListVctl(this.typeMesure);

  Future<void> getCategories() async {
    final res = await categorieApi.list().load();
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

  List<int> selected() => categoriesType
      .where((e) => e.categorieMesure != null)
      .map((e) => e.categorieMesure!.id.value)
      .toList();

  Future<void> submit(List<CategorieMesure> newCategories) async {
    final res = await categorieTypeMesureApi
        .createInTypeMesure(
          CreateCategorieTypeMesureDto(
            typeMesureId: typeMesure.id.value,
            categories: newCategories.map((e) => e.id.value).toList(),
          ),
        )
        .load();
    if (res.status) {
      categoriesType = res.data!;
      update();
      Get.back();
    } else {
      CAlertDialog.show(message: res.message);
    }
  }

  Future<void> delete(int id) async {
    final rep = await CChoiceMessageDialog.show(
      message: "Voulez-vous vraiment supprimer cette catégorie de mesure ?",
    );
    if (rep == true) {
      final res = await categorieTypeMesureApi.delete(id).load();
      if (res.status) {
        categoriesType.removeWhere((e) => e.id.value == id);
        update();
      } else {
        CAlertDialog.show(message: res.message);
      }
    }
  }

  @override
  void onReady() {
    getList();
    super.onReady();
  }
}
