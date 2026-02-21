import 'dart:io';

import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/views/controllers/auth/profil_page_vctl.dart';
import 'package:ateliya/views/static/auth/update_password_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
            backgroundColor: Colors.grey[50], // Fond premium
            appBar: AppBar(
              title: const Text("Mon profil"),
              elevation: 0,
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Profil"),
                  Tab(text: "Entreprise"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // ── Onglet Profil ──────────────────────────────────────────
                Form(
                  key: ctl.formKey,
                  child: ListView(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 50,
                      top: 20,
                    ),
                    children: [
                      // Avatar central
                      Center(
                        child: GestureDetector(
                          onTap: ctl.pickUserLogo,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(4),
                                child: ClipOval(
                                  child: _buildAvatarImage(
                                    fichier: ctl.logoUserPath,
                                    fallbackUrl:
                                        ctl.user.photoProfil.value.isNotEmpty
                                            ? ctl.user.photoProfil.value
                                            : null,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt_rounded,
                                    size: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(16),
                      // Nom et email en dessous
                      Column(
                        children: [
                          Text(
                            ctl.user.fullName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Gap(4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ctl.user.login.value,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const Gap(32),

                      // Bloc des champs (Card)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CTextFormField(
                              controller: ctl.nomCtl,
                              externalLabel: 'Nom',
                              textCapitalization: TextCapitalization.words,
                              margin: const EdgeInsets.only(bottom: 16),
                            ),
                            CTextFormField(
                              controller: ctl.prenomCtl,
                              externalLabel: 'Prénom(s)',
                              require: true,
                              textCapitalization: TextCapitalization.words,
                              margin: const EdgeInsets.only(bottom: 16),
                            ),
                            CTextFormField(
                              initialValue: ctl.user.login.value,
                              enabled: false,
                              externalLabel: 'Email (Non modifiable)',
                              margin: EdgeInsets.zero,
                              fillColor: Colors.grey[50], // champ grisé
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),

                      CButton(
                        title: 'Enregistrer mon profil',
                        onPressed: ctl.submitProfil,
                      ),
                      const Gap(24),

                      Center(
                        child: TextButton.icon(
                          onPressed: () =>
                              Get.to(() => const UpdatePasswordPage()),
                          icon: const Icon(Icons.lock_outline_rounded,
                              size: 18, color: AppColors.primary),
                          label: const Text(
                            'Changer mon mot de passe',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.05),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Onglet Entreprise ──────────────────────────────────────
                PlaceholderBuilder(
                  condition: !ctl.isEntrepriseInfoLoading,
                  placeholder: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  builder: () {
                    final isAdmin = ctl.user.isAdmin;
                    return Form(
                      key: GlobalKey<
                          FormState>(), // Eviter les soucis de key unique
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: isAdmin ? ctl.pickEntrepriseLogo : null,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.08),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: ClipOval(
                                      child: _buildAvatarImage(
                                        fichier: ctl.logoEntreprisePath,
                                        fallbackUrl: (ctl.user.entreprise?.logo
                                                is FichierServer)
                                            ? (ctl.user.entreprise?.logo
                                                    as FichierServer)
                                                .fullUrl
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (isAdmin)
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(
                                          Icons.camera_alt_rounded,
                                          size: 20,
                                          color: Colors.white),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(32),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                CTextFormField(
                                  enabled: isAdmin,
                                  controller: ctl.nomEntrepriseCtl,
                                  externalLabel: "Nom de l'entreprise",
                                  require: true,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  fillColor: !isAdmin ? Colors.grey[50] : null,
                                ),
                                CTextFormField(
                                  enabled: isAdmin,
                                  controller: ctl.emailEntrepriseCtl,
                                  externalLabel: 'Email',
                                  require: true,
                                  keyboardType: TextInputType.emailAddress,
                                  margin: const EdgeInsets.only(bottom: 16),
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
                          const Gap(24),
                          if (isAdmin)
                            CButton(
                              title: "Enregistrer l'entreprise",
                              onPressed: ctl.submitEntreprise,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Retourne un widget image gérant élégamment les types de Fichier
  Widget _buildAvatarImage({dynamic fichier, String? fallbackUrl}) {
    if (fichier is FichierLocal) {
      return Image.file(
        File(fichier.path),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }
    if (fallbackUrl != null && fallbackUrl.isNotEmpty) {
      return Image.network(
        fallbackUrl,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }
    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    return Container(
      color: Colors.grey[100],
      child: Icon(Icons.person_rounded, size: 60, color: Colors.grey[400]),
    );
  }
}
