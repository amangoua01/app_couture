import 'package:ateliya/api/modele_boutique_api.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/ravitaillement_stock.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RavitaillementListVctl extends AuthViewController {
  final api = ModeleBoutiqueApi();

  bool isLoading = false;
  List<RavitaillementStock> items = [];
  int _page = 1;
  bool hasMore = true;

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }

  Future<void> fetchData({bool refresh = true}) async {
    final entite = getEntite().value;
    if (entite.isEmpty || entite is! Boutique) return;

    if (refresh) {
      _page = 1;
      hasMore = true;
    }

    isLoading = true;
    update();

    final res = await api.getListStock(
      boutiqueId: entite.id!,
      page: _page,
      limit: 20,
    );

    isLoading = false;

    if (res.status) {
      final newItems = res.data ?? [];
      if (refresh) {
        items = newItems;
      } else {
        items.addAll(newItems);
      }
      hasMore = newItems.length >= 20;
      _page++;
    } else {
      CMessageDialog.show(message: res.message);
    }

    update();
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoading) return;
    await fetchData(refresh: false);
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> confirmer(RavitaillementStock item) async {
    final commentaire = await _showCommentDialog(
      title: 'Confirmer le ravitaillement',
      hint: 'Ex : Colis reçu en bon état',
      confirmLabel: 'Confirmer',
      confirmColor: Colors.green,
    );
    if (commentaire == null) return; // annulé

    final res =
        await api.confirmerStock(item.id!, commentaire: commentaire).load();
    if (res.status) {
      item.statut = 'CONFIRME';
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  Future<void> rejeter(RavitaillementStock item) async {
    final commentaire = await _showCommentDialog(
      title: 'Rejeter le ravitaillement',
      hint: 'Ex : Colis endommagé lors du transport',
      confirmLabel: 'Rejeter',
      confirmColor: Colors.red,
    );
    if (commentaire == null) return; // annulé

    final res =
        await api.rejeterStock(item.id!, commentaire: commentaire).load();
    if (res.status) {
      item.statut = 'REJETE';
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  /// Ouvre un dialog avec un champ commentaire optionnel.
  /// Retourne le texte saisi si confirmé, null si annulé.
  Future<String?> _showCommentDialog({
    required String title,
    required String hint,
    required String confirmLabel,
    required Color confirmColor,
  }) {
    final ctl = TextEditingController();
    return Get.dialog<String>(
      AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctl,
          decoration: InputDecoration(hintText: hint),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<String>(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Get.back<String>(result: ctl.text.trim()),
            style: TextButton.styleFrom(foregroundColor: confirmColor),
            child: Text(confirmLabel,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
