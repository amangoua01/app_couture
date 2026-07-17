import 'package:ateliya/data/models/user_adresse.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mall_ya/mes_adresses_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MesAdressesPage extends StatelessWidget {
  const MesAdressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MesAdressesVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text(
              'Mes adresses',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            backgroundColor: const Color(0xFF062A22),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF062A22),
            foregroundColor: Colors.white,
            onPressed: () => _showBottomSheet(context, ctl),
            child: const Icon(Icons.add_rounded),
          ),
          body: ctl.adresses.isEmpty
              ? const Center(
                  child: Text(
                    'Aucune adresse enregistrée.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  itemCount: ctl.adresses.length,
                  separatorBuilder: (_, __) => const Gap(10),
                  itemBuilder: (_, i) => _AdresseTile(
                    item: ctl.adresses[i],
                    ctl: ctl,
                    onEdit: () =>
                        _showBottomSheet(context, ctl, item: ctl.adresses[i]),
                  ),
                ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, MesAdressesVctl ctl,
      {UserAdresse? item}) {
    ctl.showForm(item: item);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => GetBuilder<MesAdressesVctl>(
        builder: (c) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Form(
            key: c.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item == null ? 'Nouvelle adresse' : 'Modifier l\'adresse',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const Gap(16),
                CTextFormField(
                  externalLabel: 'Titre',
                  require: true,
                  controller: c.titreCtl,
                  textCapitalization: TextCapitalization.words,
                ),
                CTextFormField(
                  externalLabel: 'Adresse',
                  controller: c.adresseCtl,
                  textCapitalization: TextCapitalization.sentences,
                ),
                CTextFormField(
                  externalLabel: 'Ville',
                  controller: c.villeCtl,
                  textCapitalization: TextCapitalization.words,
                ),
                CTextFormField(
                  externalLabel: 'Téléphone',
                  controller: c.telCtl,
                  keyboardType: TextInputType.phone,
                  margin: EdgeInsets.zero,
                ),
                const Gap(20),
                CButton(
                  title: item == null ? 'Ajouter' : 'Enregistrer',
                  color: const Color(0xFF062A22),
                  onPressed: () async {
                    await c.save(item: item);
                    if (context.mounted) Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdresseTile extends StatelessWidget {
  final UserAdresse item;
  final MesAdressesVctl ctl;
  final VoidCallback onEdit;
  const _AdresseTile(
      {required this.item, required this.ctl, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.place_rounded,
                color: Color(0xFF1565C0), size: 20),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.titre,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF062A22)),
                ),
                if (item.adresse.isNotEmpty || item.ville.isNotEmpty) ...[
                  const Gap(2),
                  Text(
                    [item.adresse, item.ville]
                        .where((s) => s.isNotEmpty)
                        .join(', '),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
                if (item.telephone.isNotEmpty) ...[
                  const Gap(2),
                  Text(item.telephone,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded,
                color: AppColors.primary, size: 20),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 20),
            onPressed: () => ctl.delete(item),
          ),
        ],
      ),
    );
  }
}
