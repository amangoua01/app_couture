import 'package:ateliya/api/charge_api.dart';
import 'package:ateliya/api/famille_depense_api.dart';
import 'package:ateliya/data/models/charge.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:get/get.dart';

class ChargesListVctl extends GetxController {
  final api = ChargeApi();
  final familleDepenseApi = FamilleDepenseApi();

  List<Charge> charges = [];
  bool isLoading = true;

  @override
  void onReady() {
    super.onReady();
    fetchCharges();
  }

  Future<void> fetchCharges() async {
    // Réaffiche les dernières charges connues le temps que le réseau réponde.
    final cached = await api.readCachedList();
    if (cached != null) {
      charges = cached;
      update();
    }

    isLoading = cached == null;
    update();

    final res = await api.list();
    isLoading = false;
    if (res.status) {
      charges = res.data!;
    } else if (cached == null) {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  Future<List<FamilleDepense>> getTypes() async {
    final res = await familleDepenseApi.list();
    return res.status ? res.data!.items : [];
  }

  Future<bool> saveCharge(Charge charge) async {
    final res =
        charge.id == null ? await api.create(charge) : await api.update(charge);
    if (!res.status) {
      CMessageDialog.show(message: res.message);
      return false;
    }

    if (charge.id == null) {
      charges.insert(0, res.data!);
    } else {
      final index = charges.indexWhere((e) => e.id == charge.id);
      if (index != -1) charges[index] = res.data!;
    }
    update();
    return true;
  }

  Future<void> deleteCharge(Charge charge) async {
    final confirmed = await CChoiceMessageDialog.show(
      message: "Supprimer la charge \"${charge.libelle}\" ?",
    );
    if (confirmed != true) return;

    final res = await api.delete(charge.id!);
    if (res.status) {
      charges.removeWhere((e) => e.id == charge.id);
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }
}
