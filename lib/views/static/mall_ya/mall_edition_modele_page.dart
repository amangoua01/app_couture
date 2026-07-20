import 'package:ateliya/data/models/mall_modele_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_image_picker_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_edition_modele_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MallEditionModelePage extends StatelessWidget {
  final MallModeleBoutique item;
  const MallEditionModelePage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MallEditionModeleVctl(item: item),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
            title: const Text(
              'Modifier le modèle',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              // Prix
              CTextFormField(
                externalLabel: 'Prix (FCFA)',
                controller: ctl.prixCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                hintText: 'Ex: 15000',
              ),
              const Gap(4),

              // Visibilité Mall
              _SectionCard(
                title: 'Visibilité Mall',
                subtitle: 'Gérer la visibilité',
                child: _ToggleRow(
                  icon: Icons.visibility_rounded,
                  iconColor: AppColors.primary,
                  title: 'Visible sur le mall',
                  subtitle: 'Afficher ce modèle aux clients',
                  value: ctl.isVisible,
                  onChanged: ctl.toggleVisible,
                ),
              ),
              const Gap(12),

              // Options
              _SectionCard(
                title: 'Options',
                child: Column(
                  children: [
                    _ToggleRow(
                      icon: Icons.fiber_new_rounded,
                      iconColor: const Color(0xFF1565C0),
                      title: 'Nouveauté',
                      subtitle:
                          'Mettre en avant ce modèle dans la section Nouveautés',
                      value: ctl.isNouveaute,
                      onChanged: ctl.toggleNouveaute,
                    ),
                    const Divider(height: 20),
                    _ToggleRow(
                      icon: Icons.straighten_rounded,
                      iconColor: const Color(0xFF6A1B9A),
                      title: 'Sur Mesure',
                      subtitle:
                          'Indique que ce modèle peut être fait sur mesure',
                      value: ctl.isSurMesure,
                      onChanged: ctl.toggleSurMesure,
                    ),
                    const Divider(height: 20),
                    _ToggleRow(
                      icon: Icons.local_offer_rounded,
                      iconColor: const Color(0xFFC2185B),
                      title: 'Promotion',
                      subtitle: 'Activer une réduction pour ce modèle',
                      value: ctl.isPromotion,
                      onChanged: ctl.togglePromotion,
                    ),
                  ],
                ),
              ),
              const Gap(12),

              // Images
              _SectionCard(
                title: 'Images',
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: CImagePickerField(
                        label: 'Image de promotion / nouveauté',
                        path: ctl.imagePromo?.path,
                        onChanged: ctl.setImagePromo,
                        onDelete: () {
                          ctl.imagePromo = null;
                          ctl.update();
                        },
                      ),
                    ),
                    const Gap(16),
                    SizedBox(
                      height: 160,
                      child: CImagePickerField(
                        label: 'Photo',
                        path: ctl.photo?.path ??
                            item.modele?.photo?.fullUrl,
                        onChanged: ctl.setPhoto,
                        onDelete: () {
                          ctl.photo = null;
                          ctl.update();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),

              CButton(
                title: 'Enregistrer',
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                onPressed: ctl.save,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({required this.title, this.subtitle, required this.child});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF062A22),
            ),
          ),
          if (subtitle != null) ...[
            const Gap(2),
            Text(subtitle!,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
          const Gap(14),
          child,
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Color(0xFF062A22))),
              Text(subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
