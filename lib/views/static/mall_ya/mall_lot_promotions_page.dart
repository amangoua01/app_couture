import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/services/image_picker_service.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_lot_promotions_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

const _kColor = Color(0xFFC2185B);

class MallLotPromotionsPage extends StatelessWidget {
  final List<MallModeleBoutique> modeles;
  const MallLotPromotionsPage({super.key, required this.modeles});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MallLotPromotionsVctl(modeles: modeles),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text(
              'Créer des offres promotionnelles',
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
            children: [
              // Info banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _kColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _kColor.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: _kColor, size: 18),
                    Gap(10),
                    Expanded(
                      child: Text(
                        'Ajoutez plusieurs offres promotionnelles en une seule fois. Chaque ligne est un lot indépendant.',
                        style: TextStyle(
                            fontSize: 12, color: _kColor, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              ...List.generate(
                ctl.lignes.length,
                (i) => _LigneCard(
                  index: i,
                  ligne: ctl.lignes[i],
                  modeles: modeles,
                  ctl: ctl,
                ),
              ),
              const Gap(12),
              // Bouton ajouter ligne
              GestureDetector(
                onTap: ctl.addLigne,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: _kColor.withValues(alpha: 0.3),
                        style: BorderStyle.solid),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline_rounded,
                          color: _kColor, size: 18),
                      Gap(8),
                      Text('Ajouter une ligne',
                          style: TextStyle(
                              color: _kColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              Text(
                '${ctl.lignes.length} ligne${ctl.lignes.length > 1 ? 's' : ''}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            child: CButton(
              title: 'Créer les promotions',
              onPressed: ctl.soumettre,
            ),
          ),
        );
      },
    );
  }
}

class _LigneCard extends StatelessWidget {
  final int index;
  final LignePromotion ligne;
  final List<MallModeleBoutique> modeles;
  final MallLotPromotionsVctl ctl;

  const _LigneCard({
    required this.index,
    required this.ligne,
    required this.modeles,
    required this.ctl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header coloré
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _kColor.withValues(alpha: 0.06),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _kColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${index + 1}',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: _kColor)),
                  ),
                ),
                const Gap(10),
                const Text('Offre promotionnelle',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: Color(0xFF062A22))),
                const Spacer(),
                if (ctl.lignes.length > 1)
                  GestureDetector(
                    onTap: () => ctl.removeLigne(index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Colors.red, size: 16),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modèle dropdown
                const _Label('Modèle boutique *'),
                const Gap(6),
                _DropdownModele(
                  modeles: modeles,
                  selected: ligne.modele,
                  hasError: ligne.modele == null,
                  onChanged: (m) => ctl.setModele(index, m),
                ),
                const Gap(14),

                // Image + Photo preview sur la même ligne
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _Label('Image'),
                          const Gap(6),
                          GestureDetector(
                            onTap: () async {
                              final f = await ImagePickerService.pickImage(
                                  from: ImageSource.gallery);
                              if (f != null) ctl.setImage(index, f);
                            },
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F7FA),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.image_outlined,
                                      color: Colors.grey, size: 16),
                                  const Gap(6),
                                  Expanded(
                                    child: Text(
                                      ligne.image != null
                                          ? ligne.image!.path.split('/').last
                                          : 'Aucun fichier choisi',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: ligne.image != null
                                              ? const Color(0xFF062A22)
                                              : Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    // Preview photo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Photo'),
                        const Gap(6),
                        GestureDetector(
                          onTap: () async {
                            final f = await ImagePickerService.pickImage(
                                from: ImageSource.gallery);
                            if (f != null) ctl.setImage(index, f);
                          },
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F7FA),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ligne.image != null
                                      ? _kColor.withValues(alpha: 0.4)
                                      : Colors.grey.withValues(alpha: 0.2)),
                            ),
                            child: ligne.image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: Image.file(ligne.image!,
                                        fit: BoxFit.cover),
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: Colors.grey,
                                          size: 20),
                                      if (ligne.image != null)
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: GestureDetector(
                                            onTap: () =>
                                                ctl.setImage(index, null),
                                            child: const Icon(
                                                Icons.close_rounded,
                                                color: Colors.red,
                                                size: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(14),

                // Qté + Nb stock + Px lot
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _Label('Qté'),
                          const Gap(6),
                          _InputField(
                            controller: ligne.qteCtrl,
                            hint: '1',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _Label('Nb stock'),
                          const Gap(6),
                          _InputField(
                            controller: ligne.nombreStockCtrl,
                            hint: '0',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _Label('Px lot'),
                          const Gap(6),
                          _PriceField(
                              controller: ligne.prixLotCtrl, hint: '25000'),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(12),

                // Px/unité + Fin
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _Label('Px/unité'),
                          const Gap(6),
                          _PriceField(
                              controller: ligne.prixUniteCtrl, hint: '14000'),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _Label('Fin'),
                          const Gap(6),
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.now().add(const Duration(days: 7)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                                locale: const Locale('fr'),
                              );
                              if (picked != null) ctl.setDateFin(index, picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F7FA),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded,
                                      color: ligne.dateFin != null
                                          ? _kColor
                                          : Colors.grey,
                                      size: 14),
                                  const Gap(6),
                                  Expanded(
                                    child: Text(
                                      ligne.finCtrl.text.isEmpty
                                          ? 'jj/mm/aaaa'
                                          : ligne.finCtrl.text,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ligne.finCtrl.text.isEmpty
                                              ? Colors.grey
                                              : const Color(0xFF062A22)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(12),

                // Actif toggle
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.toggle_on_rounded,
                          color: Colors.grey, size: 18),
                      const Gap(8),
                      const Text('Actif',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF062A22))),
                      const Spacer(),
                      Switch.adaptive(
                        value: ligne.actif,
                        activeColor: AppColors.primary,
                        onChanged: (v) => ctl.toggleActif(index, v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownModele extends StatelessWidget {
  final List<MallModeleBoutique> modeles;
  final MallModeleBoutique? selected;
  final bool hasError;
  final void Function(MallModeleBoutique?) onChanged;

  const _DropdownModele({
    required this.modeles,
    required this.selected,
    required this.hasError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: hasError
                ? Colors.red.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MallModeleBoutique>(
          value: selected,
          isExpanded: true,
          hint: const Text('Sélectionner un modèle...',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
          items: modeles
              .map((m) => DropdownMenuItem(
                    value: m,
                    child: Text(
                      m.modele?.libelle ?? '—',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF062A22)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _PriceField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InputField(
            controller: controller,
            hint: hint,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        const Gap(6),
        const Text('FCFA',
            style: TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey));
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.keyboardType,
    required this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 13, color: Color(0xFF062A22)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
