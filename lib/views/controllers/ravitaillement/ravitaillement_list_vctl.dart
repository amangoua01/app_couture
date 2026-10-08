import 'package:ateliya/api/modele_boutique_api.dart';
import 'package:ateliya/data/models/boutique.dart';
import 'package:ateliya/data/models/ravitaillement_stock.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RavitaillementListVctl extends AuthViewController {
  final api = ModeleBoutiqueApi();

  bool isLoading = false;
  List<RavitaillementStock> items = [];
  String? errorMessage;
  int _page = 1;
  bool hasMore = true;

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now().add(const Duration(days: 30)),
  );

  void updateDateRange(DateTimeRange range) {
    dateRange = range;
    fetchData();
  }


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

      // Réaffiche la dernière page connue le temps que le réseau réponde,
      // au lieu de vider l'écran à chaque ouverture.
      if (items.isEmpty) {
        final cached = await api.readCachedStock(entite.id!);
        if (cached != null) {
          items = cached;
          update();
        }
      }
    }

    isLoading = items.isEmpty;
    errorMessage = null;
    update();

    final dateDebut = dateRange.start.toIso8601String().split('T')[0];
    final dateFin = dateRange.end.toIso8601String().split('T')[0];

    final res = await api.getListStock(
      boutiqueId: entite.id!,
      page: _page,
      limit: 20,
      dateDebut: dateDebut,
      dateFin: dateFin,
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
      errorMessage = res.message;
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
      confirmColor: AppColors.green,
      icon: Icons.check_circle_outline,
    );
    if (commentaire == null) return; // annulé

    final res =
        await api.confirmerStock(item.id!, commentaire: commentaire).load();
    if (res.status) {
      item.statut = 'CONFIRME';
      update();
      Get.back(result: true);
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  Future<void> rejeter(RavitaillementStock item) async {
    final commentaire = await _showCommentDialog(
      title: 'Rejeter le ravitaillement',
      hint: 'Ex : Colis endommagé lors du transport',
      confirmLabel: 'Rejeter',
      confirmColor: const Color(0xFFC0392B),
      icon: Icons.cancel_outlined,
    );
    if (commentaire == null) return; // annulé

    final res =
        await api.rejeterStock(item.id!, commentaire: commentaire).load();
    if (res.status) {
      item.statut = 'REJETE';
      update();
      Get.back(result: true);
    } else {
      CMessageDialog.show(message: res.message);
    }
  }

  /// Ouvre une feuille en bas d'écran avec un champ commentaire pré-rempli
  /// (à partir de l'exemple) : l'utilisateur peut valider tel quel ou
  /// l'adapter. Retourne le texte saisi si confirmé, null si annulé.
  Future<String?> _showCommentDialog({
    required String title,
    required String hint,
    required String confirmLabel,
    required Color confirmColor,
    required IconData icon,
  }) {
    final defaultText = hint.replaceFirst(RegExp(r'^Ex\s*:\s*'), '');
    final ctl = TextEditingController(text: defaultText);
    return Get.bottomSheet<String>(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: confirmColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: confirmColor, size: 24),
              ),
              const Gap(14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const Gap(12),
              CTextFormField(
                controller: ctl,
                hintText: hint,
                maxLines: 2,
                autofocus: true,
                margin: EdgeInsets.zero,
              ),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: CButton(
                      title: 'Annuler',
                      color: Colors.white,
                      textColor: AppColors.primary,
                      border: const BorderSide(color: AppColors.fieldBorder),
                      onPressed: () => Get.back<String>(),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: CButton(
                      title: confirmLabel,
                      color: confirmColor,
                      onPressed: () => Get.back<String>(result: ctl.text.trim()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }
}
