import 'package:ateliya/api/categorie_mesure_api.dart';
import 'package:ateliya/api/categorie_type_mesure_api.dart';
import 'package:ateliya/data/dto/create_categorie_type_mesure_dto.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';
import 'package:ateliya/data/models/categorie_type_mesure.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:get/get.dart';

class CategorieTypeMesureListVctl extends GetxController {
  final TypeMesure typeMesure;
  final categorieApi = CategorieMesureApi();
  bool isLoading = false;
  bool isOrderChanged = false;

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
      CMessageDialog.show(message: res.message);
    }
  }

  Future<void> getList() async {
    isLoading = true;
    update();
    final res = await categorieTypeMesureApi.list(id: typeMesure.id);
    isLoading = false;
    isOrderChanged = false;
    update();
    if (res.status) {
      categoriesType = res.data!.items;
      update();
    } else {
      CMessageDialog.show(message: res.message);
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
      CMessageDialog.show(message: res.message);
    }
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = categoriesType.removeAt(oldIndex);
    categoriesType.insert(newIndex, item);

    // Mettre à jour les ordres locaux
    for (int i = 0; i < categoriesType.length; i++) {
      categoriesType[i].ordre = i + 1;
    }

    isOrderChanged = true;
    update();
  }

  Future<void> saveNewOrder() async {
    isLoading = true;
    update();

    List<Map<String, dynamic>> ordres = categoriesType
        .map((e) => {"id": e.id.value, "ordre": e.ordre})
        .toList();

    final res = await categorieTypeMesureApi.changeOrdreMultiple(ordres).load();

    isLoading = false;
    if (res.status) {
      isOrderChanged = false;
      update();
    } else {
      CMessageDialog.show(
          message: "Erreur lors de la sauvegarde de l'ordre : ${res.message}");
      // Revert if error
      getList();
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
        CMessageDialog.show(message: res.message);
      }
    }
  }

  @override
  void onReady() {
    getList();
    super.onReady();
  }
}
