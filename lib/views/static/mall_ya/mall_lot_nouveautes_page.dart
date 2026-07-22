import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/services/image_picker_service.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_lot_nouveautes_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MallLotNouveautesPage extends StatelessWidget {
  final List<MallModeleBoutique> modeles;
  const MallLotNouveautesPage({super.key, required this.modeles});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MallLotNouveautesVctl(modeles: modeles),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text('Nouveautés'),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFF1565C0).withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: Color(0xFF1565C0), size: 18),
                    Gap(10),
                    Expanded(
                      child: Text(
                        'Marquez plusieurs modèles comme nouveautés sur le Mall. Chaque ligne est une entrée distincte.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1565C0),
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              ...List.generate(ctl.lignes.length, (i) {
                final ligne = ctl.lignes[i];
                return _LigneCard(
                  index: i,
                  ligne: ligne,
                  modeles: modeles,
                  ctl: ctl,
                );
              }),
              const Gap(12),
              GestureDetector(
                onTap: ctl.addLigne,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFF1565C0).withValues(alpha: 0.3),
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
                          color: Color(0xFF1565C0), size: 18),
                      Gap(8),
                      Text('Ajouter une ligne',
                          style: TextStyle(
                              color: Color(0xFF1565C0),
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
                title: 'Déclarer les nouveautés', onPressed: ctl.soumettre),
          ),
        );
      },
    );
  }
}

class _LigneCard extends StatelessWidget {
  final int index;
  final LigneNouveaute ligne;
  final List<MallModeleBoutique> modeles;
  final MallLotNouveautesVctl ctl;

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
      padding: const EdgeInsets.all(14),
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
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('${index + 1}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1565C0))),
                ),
              ),
              const Gap(8),
              const Text('Nouveauté',
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
          const Gap(12),
          // Modèle dropdown
          const _Label('Modèle boutique *'),
          const Gap(6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: ligne.modele == null
                      ? Colors.red.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.2)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<MallModeleBoutique>(
                value: ligne.modele,
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
                onChanged: (m) => ctl.setModele(index, m),
              ),
            ),
          ),
          const Gap(12),
          // Image picker
          const _Label('Image'),
          const Gap(6),
          GestureDetector(
            onTap: () async {
              final f =
                  await ImagePickerService.pickImage(from: ImageSource.gallery);
              if (f != null) ctl.setImage(index, f);
            },
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image_outlined,
                      color: Colors.grey, size: 18),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      ligne.image != null
                          ? ligne.image!.path.split('/').last
                          : 'Aucun fichier choisi',
                      style: TextStyle(
                          fontSize: 12,
                          color: ligne.image != null
                              ? const Color(0xFF062A22)
                              : Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (ligne.image != null)
                    GestureDetector(
                      onTap: () => ctl.setImage(index, null),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.grey, size: 16),
                    ),
                ],
              ),
            ),
          ),
          const Gap(12),
          // Qté + Nb stock + Prix sur la même ligne
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    const _Label('Nvx prix'),
                    const Gap(6),
                    Row(
                      children: [
                        Expanded(
                          child: _InputField(
                            controller: ligne.prixCtrl,
                            hint: '0',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        const Gap(6),
                        const Text('FCFA',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(12),
          // Actif toggle
          Row(
            children: [
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
        ],
      ),
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
