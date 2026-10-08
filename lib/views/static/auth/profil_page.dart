import 'dart:io';

import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/c_tab_bar.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/views/controllers/auth/profil_page_vctl.dart';
import 'package:ateliya/views/static/auth/update_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// Mon profil.
///
/// L'identité (photo, nom, e-mail) est présentée dans un bandeau continu avec
/// l'en-tête de l'écran, et non posée sur le fond comme un élément flottant.
/// Les champs sont ensuite répartis en sections nommées — identité, sécurité,
/// puis zone sensible — pour que chaque action se trouve du premier coup
/// d'œil plutôt que d'être noyée dans un seul long bloc.
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilPageVctl>(
      init: ProfilPageVctl(),
      builder: (ctl) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            // Pas d'AppBar ici : le thème lui arrondit le bas de 16 px, ce qui
            // laissait apparaître le fond de l'écran dans les deux angles,
            // juste au-dessus du bandeau. Titre et retour sont donc intégrés
            // au bandeau, qui descend d'un seul tenant depuis la barre d'état.
            body: Column(
              children: [
                _IdentityBanner(ctl: ctl),
                const CTabBar(
                  tabs: ["Profil", "Entreprise"],
                  margin: EdgeInsets.fromLTRB(20, 14, 20, 4),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _ProfilTab(ctl: ctl),
                      _EntrepriseTab(ctl: ctl),
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

/// Bandeau d'identité : porte à lui seul la barre de titre, la photo, le nom
/// et l'e-mail, d'un seul tenant depuis la barre d'état jusqu'à son bord
/// inférieur arrondi. Il remplace l'AppBar de l'écran, dont le bas arrondi
/// créait une cassure visible entre les deux blocs.
class _IdentityBanner extends StatelessWidget {
  final ProfilPageVctl ctl;
  const _IdentityBanner({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Sans AppBar, personne ne réclame des icônes de barre d'état claires.
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top,
          bottom: 22,
        ),
        child: Column(
          children: [
            const _BannerTitleBar(),
            _AvatarPicker(
              onTap: ctl.pickUserLogo,
              fichier: ctl.logoUserPath,
              fallbackUrl: ctl.user.photoProfil.value.isNotEmpty
                  ? ctl.user.photoProfil.value
                  : null,
              editable: true,
            ),
            const Gap(12),
            Text(
              ctl.user.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            const Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                ctl.user.login.value,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Retour + titre, à la place de l'AppBar supprimée.
class _BannerTitleBar extends StatelessWidget {
  const _BannerTitleBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: Get.back,
              tooltip: "Retour",
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const Center(
            child: Text(
              "Mon profil",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilTab extends StatelessWidget {
  final ProfilPageVctl ctl;
  const _ProfilTab({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: ctl.formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          const _SectionTitle("Identité"),
          _SectionCard(
            child: Column(
              children: [
                CTextFormField(
                  controller: ctl.nomCtl,
                  externalLabel: 'Nom',
                  textCapitalization: TextCapitalization.words,
                  margin: const EdgeInsets.only(bottom: 14),
                ),
                CTextFormField(
                  controller: ctl.prenomCtl,
                  externalLabel: 'Prénom(s)',
                  require: true,
                  textCapitalization: TextCapitalization.words,
                  margin: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const Gap(18),
          const _SectionTitle("Compte"),
          // L'e-mail n'est pas modifiable : le présenter comme une
          // information copiable, et non comme un champ de saisie grisé,
          // évite de laisser croire qu'on peut le corriger ici.
          _SectionCard(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.alternate_email_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Adresse e-mail",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        ctl.user.login.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: "Copier l'adresse",
                  onPressed: () async {
                    final email = ctl.user.login.value;
                    if (email.isEmpty) return;
                    await Clipboard.setData(ClipboardData(text: email));
                    CSnackbar.show(
                      message: "Email copié dans le presse-papiers !",
                      isSuccess: true,
                    );
                  },
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Gap(22),
          CButton(
            title: 'Enregistrer mon profil',
            onPressed: ctl.submitProfil,
          ),
          const Gap(26),
          const _SectionTitle("Sécurité"),
          _SectionCard(
            padding: EdgeInsets.zero,
            child: _ActionTile(
              icon: Icons.lock_outline_rounded,
              label: "Changer mon mot de passe",
              onTap: () => Get.to(() => const UpdatePasswordPage()),
            ),
          ),
          const Gap(26),
          const _SectionTitle("Zone sensible", color: AppColors.danger),
          _SectionCard(
            padding: EdgeInsets.zero,
            borderColor: AppColors.danger.withValues(alpha: 0.18),
            child: _ActionTile(
              icon: Icons.delete_outline_rounded,
              label: "Supprimer mon compte",
              description: "Cette action est définitive.",
              color: AppColors.danger,
              onTap: ctl.deleteAccount,
            ),
          ),
        ],
      ),
    );
  }
}

class _EntrepriseTab extends StatelessWidget {
  final ProfilPageVctl ctl;
  const _EntrepriseTab({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return PlaceholderBuilder(
      condition: !ctl.isEntrepriseInfoLoading,
      placeholder: const Center(child: CircularProgressIndicator()),
      builder: () {
        final isAdmin = ctl.user.isAdmin;
        final logo = ctl.user.entreprise?.logo;
        return Form(
          key: ctl.entrepriseFormKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              Center(
                child: _AvatarPicker(
                  onTap: isAdmin ? ctl.pickEntrepriseLogo : null,
                  fichier: ctl.logoEntreprisePath,
                  fallbackUrl:
                      logo is FichierServer ? logo.fullUrl : null,
                  editable: isAdmin,
                  onLightBackground: true,
                ),
              ),
              const Gap(20),
              if (!isAdmin) ...[
                // Dire pourquoi les champs sont verrouillés plutôt que de
                // laisser l'utilisateur buter sur des champs inertes.
                const _InfoNote(
                  "Seul un administrateur peut modifier les informations de "
                  "l'entreprise.",
                ),
                const Gap(16),
              ],
              const _SectionTitle("Informations de l'entreprise"),
              _SectionCard(
                child: Column(
                  children: [
                    CTextFormField(
                      enabled: isAdmin,
                      controller: ctl.nomEntrepriseCtl,
                      externalLabel: "Nom de l'entreprise",
                      require: true,
                      margin: const EdgeInsets.only(bottom: 14),
                      fillColor: !isAdmin ? Colors.grey[50] : null,
                    ),
                    CTextFormField(
                      enabled: isAdmin,
                      controller: ctl.emailEntrepriseCtl,
                      externalLabel: 'Email',
                      require: true,
                      keyboardType: TextInputType.emailAddress,
                      margin: const EdgeInsets.only(bottom: 14),
                      fillColor: !isAdmin ? Colors.grey[50] : null,
                    ),
                    CTextFormField(
                      enabled: isAdmin,
                      controller: ctl.telephoneEntrepriseCtl,
                      externalLabel: 'Téléphone',
                      require: true,
                      keyboardType: TextInputType.phone,
                      margin: EdgeInsets.zero,
                      fillColor: !isAdmin ? Colors.grey[50] : null,
                    ),
                  ],
                ),
              ),
              const Gap(22),
              if (isAdmin)
                CButton(
                  title: "Enregistrer l'entreprise",
                  onPressed: ctl.submitEntreprise,
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Photo ronde avec son bouton d'appareil photo.
class _AvatarPicker extends StatelessWidget {
  final VoidCallback? onTap;
  final dynamic fichier;
  final String? fallbackUrl;
  final bool editable;

  /// Sur fond clair, l'anneau blanc disparaît : on lui substitue une ombre.
  final bool onLightBackground;

  const _AvatarPicker({
    required this.onTap,
    required this.fichier,
    required this.fallbackUrl,
    required this.editable,
    this.onLightBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 102,
            height: 102,
            padding: const EdgeInsets.all(3.5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: onLightBackground
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: ClipOval(
              child: _AvatarImage(fichier: fichier, fallbackUrl: fallbackUrl),
            ),
          ),
          if (editable)
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 15,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final dynamic fichier;
  final String? fallbackUrl;
  const _AvatarImage({required this.fichier, required this.fallbackUrl});

  @override
  Widget build(BuildContext context) {
    if (fichier is FichierLocal) {
      return Image.file(
        File((fichier as FichierLocal).path),
        fit: BoxFit.cover,
        width: 102,
        height: 102,
      );
    }
    final url = fallbackUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: 102,
        height: 102,
        errorBuilder: (_, __, ___) => const _AvatarFallback(),
      );
    }
    return const _AvatarFallback();
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greenLight.withValues(alpha: 0.35),
      child: const Icon(
        Icons.person_rounded,
        size: 52,
        color: Colors.white,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  final Color? color;
  const _SectionTitle(this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.9,
          color: (color ?? AppColors.primary).withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;

  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? description;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.description,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    if (description != null) ...[
                      const Gap(2),
                      Text(
                        description!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: color.withValues(alpha: 0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  final String message;
  const _InfoNote(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.secondary,
          ),
          const Gap(10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8A6220),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
