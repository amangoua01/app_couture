import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/c_tab_bar.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_settings_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MallSettingsPage extends StatelessWidget {
  const MallSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MallSettingsVctl(),
      builder: (ctl) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            appBar: AppBar(
              title: const Text(
                'Paramètres boutique',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              backgroundColor: const Color(0xFF062A22),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: ctl.loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      const CTabBar(
                        tabs: ['Général', 'Nouveautés', 'Promos', 'Réseaux'],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _GeneralTab(ctl: ctl),
                            _HeaderTab(
                              badgeCtl: ctl.nouveauHeaderBadgeCtl,
                              titleCtl: ctl.nouveauHeaderTitleCtl,
                              subtitleCtl: ctl.nouveauHeaderSubtitleCtl,
                              descriptionCtl: ctl.nouveauHeaderDescriptionCtl,
                              icon: Icons.new_releases_rounded,
                              color: const Color(0xFF1565C0),
                              label: 'Nouveautés',
                              hint:
                                  'Bandeau affiché au-dessus de vos modèles marqués "Nouveau".',
                              onSave: ctl.saveNouveau,
                            ),
                            _HeaderTab(
                              badgeCtl: ctl.promoHeaderBadgeCtl,
                              titleCtl: ctl.promoHeaderTitleCtl,
                              subtitleCtl: ctl.promoHeaderSubtitleCtl,
                              descriptionCtl: ctl.promoHeaderDescriptionCtl,
                              icon: Icons.local_offer_rounded,
                              color: const Color(0xFFC2185B),
                              label: 'Promotions',
                              hint:
                                  'Bandeau affiché au-dessus de vos modèles en promotion.',
                              onSave: ctl.savePromo,
                            ),
                            _ReseauxTab(ctl: ctl),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// ── Général ──────────────────────────────────────────────────────────────────

class _GeneralTab extends StatelessWidget {
  final MallSettingsVctl ctl;
  const _GeneralTab({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        const _SectionHeader(
          icon: Icons.storefront_rounded,
          color: AppColors.primary,
          title: 'Informations générales',
          subtitle: 'Visibles par vos clients sur le Mall.',
        ),
        const Gap(16),
        _Card(children: [
          CTextFormField(
            externalLabel: 'Nom de la boutique',
            require: true,
            controller: ctl.libelleCtl,
            textCapitalization: TextCapitalization.words,
          ),
          CTextFormField(
            externalLabel: 'Email de contact',
            controller: ctl.emailCtl,
            keyboardType: TextInputType.emailAddress,
          ),
          CTextFormField(
            externalLabel: 'Téléphone',
            controller: ctl.numeroCtl,
            keyboardType: TextInputType.phone,
          ),
          CTextFormField(
            externalLabel: 'Description / À propos',
            controller: ctl.descriptionCtl,
            maxLines: 4,
            margin: EdgeInsets.zero,
            textCapitalization: TextCapitalization.sentences,
          ),
        ]),
        const Gap(24),
        CButton(
          title: 'Enregistrer',
          color: AppColors.primary,
          onPressed: ctl.saveGeneral,
        ),
      ],
    );
  }
}

// ── Nouveautés / Promotions ───────────────────────────────────────────────────

class _HeaderTab extends StatelessWidget {
  final TextEditingController badgeCtl;
  final TextEditingController titleCtl;
  final TextEditingController subtitleCtl;
  final TextEditingController descriptionCtl;
  final IconData icon;
  final Color color;
  final String label;
  final String hint;
  final Future<void> Function() onSave;

  const _HeaderTab({
    required this.badgeCtl,
    required this.titleCtl,
    required this.subtitleCtl,
    required this.descriptionCtl,
    required this.icon,
    required this.color,
    required this.label,
    required this.hint,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        _SectionHeader(
          icon: icon,
          color: color,
          title: 'Entête $label',
          subtitle: hint,
        ),
        const Gap(16),
        _Card(children: [
          CTextFormField(
            externalLabel: 'Badge (ex : Collections Récentes)',
            controller: badgeCtl,
            textCapitalization: TextCapitalization.sentences,
          ),
          CTextFormField(
            externalLabel: 'Titre principal',
            controller: titleCtl,
            textCapitalization: TextCapitalization.sentences,
          ),
          CTextFormField(
            externalLabel: 'Sous-titre',
            controller: subtitleCtl,
            textCapitalization: TextCapitalization.sentences,
          ),
          CTextFormField(
            externalLabel: 'Description longue',
            controller: descriptionCtl,
            maxLines: 4,
            margin: EdgeInsets.zero,
            textCapitalization: TextCapitalization.sentences,
          ),
        ]),
        const Gap(24),
        CButton(
          title: 'Enregistrer',
          color: color,
          onPressed: onSave,
        ),
      ],
    );
  }
}

// ── Réseaux sociaux ───────────────────────────────────────────────────────────

class _ReseauxTab extends StatelessWidget {
  final MallSettingsVctl ctl;
  const _ReseauxTab({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        const _SectionHeader(
          icon: Icons.share_rounded,
          color: Color(0xFF37474F),
          title: 'Réseaux sociaux',
          subtitle:
              'Ajoutez vos liens pour que vos clients puissent vous suivre.',
        ),
        const Gap(16),
        _Card(children: [
          _SocialField(
              icon: Icons.chat_rounded,
              color: const Color(0xFF25D366),
              label: 'WhatsApp',
              controller: ctl.whatsappCtl,
              keyboardType: TextInputType.phone),
          _SocialField(
              icon: Icons.facebook_rounded,
              color: const Color(0xFF1877F2),
              label: 'Facebook',
              controller: ctl.facebookCtl),
          _SocialField(
              icon: Icons.camera_alt_rounded,
              color: const Color(0xFFE1306C),
              label: 'Instagram',
              controller: ctl.instagramCtl),
          _SocialField(
              icon: Icons.music_note_rounded,
              color: Colors.black,
              label: 'TikTok',
              controller: ctl.tiktokCtl),
          _SocialField(
              icon: Icons.alternate_email_rounded,
              color: const Color(0xFF1DA1F2),
              label: 'Twitter / X',
              controller: ctl.twitterCtl),
          _SocialField(
              icon: Icons.play_circle_rounded,
              color: const Color(0xFFFF0000),
              label: 'YouTube',
              controller: ctl.youtubeCtl,
              isLast: true),
        ]),
        const Gap(24),
        CButton(
          title: 'Enregistrer',
          color: const Color(0xFF37474F),
          onPressed: ctl.saveReseaux,
        ),
      ],
    );
  }
}

class _SocialField extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isLast;

  const _SocialField({
    required this.icon,
    required this.color,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.url,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return CTextFormField(
      externalLabel: label,
      controller: controller,
      keyboardType: keyboardType,
      margin: isLast ? EdgeInsets.zero : const EdgeInsets.only(bottom: 20),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

// ── Widgets communs ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _SectionHeader(
      {required this.icon,
      required this.color,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w800, color: color)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}
