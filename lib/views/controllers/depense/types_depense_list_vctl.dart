import 'package:ateliya/api/famille_depense_api.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:get/get.dart';

class TypesDepenseListVctl extends GetxController {
  final api = FamilleDepenseApi();

  List<FamilleDepense> types = [];
  bool isLoading = true;

  @override
  void onReady() {
    super.onReady();
    fetchTypes();
  }

  Future<void> fetchTypes() async {
    // Réaffiche les derniers types connus le temps que le réseau réponde.
    final cached = await api.readCachedList();
    if (cached != null) {
      types = cached;
      update();
    }

    isLoading = cached == null;
    update();

    final res = await api.list();
    isLoading = false;
    if (res.status) {
      types = res.data!.items;
    } else if (cached == null) {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  Future<void> createType(String libelle) async {
    final res = await api.create(libelle);
    if (res.status) {
      types.insert(0, res.data!);
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  Future<void> deleteType(FamilleDepense type) async {
    final confirmed = await CChoiceMessageDialog.show(
      message: "Supprimer le type \"${type.libelle}\" ?",
    );
    if (confirmed != true) return;

    final res = await api.delete(type.id!);
    if (res.status) {
      types.removeWhere((e) => e.id == type.id);
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }
}
