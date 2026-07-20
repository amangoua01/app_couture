import 'package:ateliya/data/models/mall_slide.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/inputs/c_image_picker_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_couvertures_vctl.dart';
import 'package:ateliya/views/static/mall_ya/mall_detail_couverture_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MallCouverturesPage extends StatelessWidget {
  const MallCouverturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return GetBuilder(
      init: MallCouverturesVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                backgroundColor: const Color(0xFF062A22),
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF062A22),
                          AppColors.primary,
                          Color(0xFF0D5040),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(32)),
                    ),
                    padding: EdgeInsets.fromLTRB(16, topPadding + 56, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(12),
                        const Text(
                          'Couvertures boutique',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          'Gérez les bannières mises en avant sur votre vitrine.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 17),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.panorama_rounded,
                              color: Colors.white, size: 16),
                          const Gap(6),
                          Text(
                            '${ctl.slides.length} slide${ctl.slides.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              ctl.loading
                  ? const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ctl.slides.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE65100)
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.panorama_rounded,
                                      color: Color(0xFFE65100), size: 36),
                                ),
                                const Gap(16),
                                const Text(
                                  'Aucun slide de couverture',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Color(0xFF062A22),
                                  ),
                                ),
                                const Gap(6),
                                const Text(
                                  'Ajoutez une bannière pour mettre\nvotre boutique en avant.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, i) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await Get.to(() =>
                                        MallDetailCouverturePage(
                                            slide: ctl.slides[i]));
                                    if (result == 'deleted') ctl.loadSlides();
                                    if (result is MallSlide) {
                                      Get.to(() => MallDetailCouverturePage(
                                          slide: result));
                                    }
                                  },
                                  child: _SlideTile(slide: ctl.slides[i]),
                                ),
                              ),
                              childCount: ctl.slides.length,
                            ),
                          ),
                        ),
            ],
          ),
          floatingActionButton: _FabAction(
            icon: Icons.add_rounded,
            label: 'Nouveau slide',
            color: const Color(0xFFE65100),
            onTap: () => _showForm(context, ctl),
          ),
        );
      },
    );
  }

  void _showForm(BuildContext context, MallCouverturesVctl ctl) {
    ctl.clearForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SlideFormSheet(
        ctl: ctl,
        title: 'Nouveau slide',
        icon: Icons.panorama_rounded,
        buttonLabel: 'Créer le slide',
        buttonIcon: Icons.add_rounded,
        onSubmit: ctl.createSlide,
      ),
    );
  }
}

// ── Slide tile ────────────────────────────────────────────────────────────────

class _SlideTile extends StatelessWidget {
  final MallSlide slide;

  const _SlideTile({required this.slide});

  @override
  Widget build(BuildContext context) {
    final imageUrl = slide.image?.fullUrl;
    final fmt = NumberFormat('#,###', 'fr_FR');

    return Container(
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (slide.badgeText != null &&
                          slide.badgeText!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE65100),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            slide.badgeText!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Gap(6),
                      ],
                      Text(
                        slide.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Color(0xFF062A22)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (slide.subtitle != null &&
                          slide.subtitle!.isNotEmpty) ...[
                        const Gap(2),
                        Text(slide.subtitle!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                      if (slide.price != null) ...[
                        const Gap(4),
                        Text(
                          '${fmt.format(slide.price)} FCFA',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: Color(0xFFE65100)),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        height: 140,
        width: double.infinity,
        color: const Color(0xFFFBE9E7),
        child: const Icon(Icons.panorama_rounded,
            color: Color(0xFFE65100), size: 40),
      );
}

// ── Form bottom sheet (création) ──────────────────────────────────────────────

class _SlideFormSheet extends StatelessWidget {
  final MallCouverturesVctl ctl;
  final String title;
  final IconData icon;
  final String buttonLabel;
  final IconData buttonIcon;
  final VoidCallback onSubmit;

  const _SlideFormSheet({
    required this.ctl,
    required this.title,
    required this.icon,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onSubmit,
  });

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
                  child: Icon(icon, color: const Color(0xFFE65100), size: 18),
                ),
                const Gap(10),
                Text(
                  title,
                  style: const TextStyle(
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
              onTap: () {
                Get.back();
                onSubmit();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE65100),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(buttonIcon, color: Colors.white, size: 18),
                    const Gap(8),
                    Text(
                      buttonLabel,
                      style: const TextStyle(
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

// ── FAB action ────────────────────────────────────────────────────────────────

class _FabAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FabAction({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const Gap(6),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
