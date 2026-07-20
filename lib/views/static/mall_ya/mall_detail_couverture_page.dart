import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_slide.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/inputs/c_image_picker_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_couvertures_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MallDetailCouverturePage extends StatelessWidget {
  final MallSlide slide;

  const MallDetailCouverturePage({super.key, required this.slide});

  Future<void> _delete() async {
    final confirm = await CChoiceMessageDialog.show(
      message: 'Voulez-vous vraiment supprimer ce slide ?',
      validText: 'Supprimer',
      cancelText: 'Annuler',
      secondaryColor: Colors.red,
    );
    if (confirm != true) return;
    final res = await MallApi().deleteSlide(slide.id).load();
    if (res.status) {
      CSnackbar.show(message: 'Slide supprimé avec succès', isSuccess: true);
      Get.back(result: 'deleted');
    } else {
      CSnackbar.show(message: res.message ?? 'Erreur inconnue');
    }
  }

  void _edit(BuildContext context) {
    final ctl = Get.find<MallCouverturesVctl>();
    ctl.fillForm(slide);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SlideFormSheet(ctl: ctl, slideId: slide.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = slide.image?.fullUrl;
    final fmt = NumberFormat('#,###', 'fr_FR');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            collapsedHeight: 80,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF062A22),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _photoPlaceholder(),
                    )
                  : _photoPlaceholder(),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 17),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                        if (slide.badgeText != null &&
                            slide.badgeText!.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE65100),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              slide.badgeText!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const Gap(10),
                        ],
                        Text(
                          slide.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF062A22),
                          ),
                        ),
                        if (slide.price != null) ...[
                          const Gap(6),
                          Text(
                            '${fmt.format(slide.price)} FCFA',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFE65100),
                            ),
                          ),
                        ],
                        if (slide.subtitle != null &&
                            slide.subtitle!.isNotEmpty) ...[
                          const Gap(12),
                          const Divider(height: 1),
                          const Gap(12),
                          _InfoRow(
                            icon: Icons.short_text_rounded,
                            label: 'Sous-titre',
                            value: slide.subtitle!,
                          ),
                        ],
                        if (slide.description != null &&
                            slide.description!.isNotEmpty) ...[
                          const Gap(10),
                          _InfoRow(
                            icon: Icons.notes_rounded,
                            label: 'Description',
                            value: slide.description!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Gap(24),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.edit_rounded,
                          label: 'Modifier',
                          color: const Color(0xFF062A22),
                          onTap: () => _edit(context),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.delete_rounded,
                          label: 'Supprimer',
                          color: Colors.red,
                          onTap: _delete,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder() => Container(
        color: const Color(0xFFFBE9E7),
        child: const Center(
          child:
              Icon(Icons.panorama_rounded, color: Color(0xFFE65100), size: 80),
        ),
      );
}

// ── Info row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFF062A22).withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: const Color(0xFF062A22)),
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF062A22),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const Gap(8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Form bottom sheet ─────────────────────────────────────────────────────────

class _SlideFormSheet extends StatelessWidget {
  final MallCouverturesVctl ctl;
  final int slideId;

  const _SlideFormSheet({required this.ctl, required this.slideId});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: EdgeInsets.fromLTRB(
              20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_rounded,
                      color: Color(0xFFE65100), size: 18),
                ),
                const Gap(10),
                const Text(
                  'Modifier le slide',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF062A22)),
                ),
              ],
            ),
            const Gap(20),
            CTextFormField(
              externalLabel: 'Titre',
              require: true,
              controller: ctl.titleCtl,
              textCapitalization: TextCapitalization.sentences,
            ),
            CTextFormField(
              externalLabel: 'Sous-titre',
              controller: ctl.subtitleCtl,
              textCapitalization: TextCapitalization.sentences,
            ),
            CTextFormField(
              externalLabel: 'Description',
              controller: ctl.descriptionCtl,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            CTextFormField(
              externalLabel: 'Badge (ex : Premium)',
              controller: ctl.badgeCtl,
              textCapitalization: TextCapitalization.words,
            ),
            CTextFormField(
              externalLabel: 'Prix (optionnel)',
              controller: ctl.priceCtl,
              keyboardType: TextInputType.number,
            ),
            const Gap(4),
            SizedBox(
              height: 160,
              child: GetBuilder<MallCouverturesVctl>(
                builder: (c) => CImagePickerField(
                  label: 'Image de couverture',
                  path: c.imageFile?.path ?? c.existingImageUrl,
                  onChanged: c.setImage,
                  onDelete: c.removeImage,
                ),
              ),
            ),
            const Gap(24),
            GestureDetector(
              onTap: () => ctl.updateSlide(slideId),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE65100),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_rounded, color: Colors.white, size: 18),
                    Gap(8),
                    Text(
                      'Enregistrer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
