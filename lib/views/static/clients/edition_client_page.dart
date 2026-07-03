import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/type_user_enum.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/views/controllers/clients/edition_client_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditionClientPage extends StatelessWidget {
  final Client? item;
  const EditionClientPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditionClientPageVctl(item),
      builder: (ctl) {
        final isEdit = ctl.item != null;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: Text(
              isEdit ? "Modifier le client" : "Ajouter un client",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            elevation: 0,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: CButton(
                  onPressed: ctl.submit,
                  title: isEdit
                      ? "Enregistrer les modifications"
                      : "Enregistrer le client",
                ),
              ),
            ),
          ),
          body: Form(
            key: ctl.formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                // Centered avatar selector with camera badge
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () => ctl.pickPhoto(),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: (ctl.photo == null)
                                ? null
                                : (ctl.photo is FichierServer)
                                    ? NetworkImage(
                                        (ctl.photo as FichierServer).fullUrl!,
                                      )
                                    : FileImage(
                                        (ctl.photo as FichierLocal).file,
                                      ) as ImageProvider,
                            child: Visibility(
                              visible: ctl.photo == null,
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person_rounded,
                                        color: Colors.grey, size: 40),
                                    Gap(4),
                                    Text(
                                      "Photo",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
                const Gap(32),

                // Card 1: Informations personnelles
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informations personnelles",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const Gap(16),
                      CTextFormField(
                        externalLabel: "Nom",
                        require: true,
                        controller: ctl.nomCtl,
                        textCapitalization: TextCapitalization.words,
                      ),
                      CTextFormField(
                        externalLabel: "Prénom(s)",
                        require: true,
                        controller: ctl.prenomCtl,
                        textCapitalization: TextCapitalization.words,
                      ),
                      CTextFormField(
                        externalLabel: "Téléphone",
                        require: true,
                        controller: ctl.telCtl,
                        keyboardType: TextInputType.number,
                        margin: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ).animate().fade(duration: 300.ms).slideY(begin: 0.05, end: 0),
                const Gap(20),

                // Card 2: Boutique / Succursale
                Visibility(
                  visible: [TypeUserEnum.adb, TypeUserEnum.adsb]
                          .contains(ctl.user.typeEnum) ||
                      [TypeUserEnum.adsb, TypeUserEnum.ads]
                          .contains(ctl.user.typeEnum) ||
                      ctl.user.isAdmin,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rattachement commercial",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Gap(16),
                        Visibility(
                          visible: [TypeUserEnum.adb, TypeUserEnum.adsb]
                                  .contains(ctl.user.typeEnum) ||
                              ctl.user.isAdmin,
                          child: CDropDownFormField(
                            selectedItem: ctl.boutique,
                            items: (e, f) => ctl.fetchBoutiques(),
                            externalLabel: "Boutique",
                            itemAsString: (e) => e.libelle.value,
                            onChanged: (e) {
                              ctl.boutique = e;
                              ctl.update();
                            },
                          ),
                        ),
                        Visibility(
                          visible: [TypeUserEnum.adsb, TypeUserEnum.ads]
                                  .contains(ctl.user.typeEnum) ||
                              ctl.user.isAdmin,
                          child: CDropDownFormField(
                            selectedItem: ctl.succursale,
                            externalLabel: "Succursale",
                            itemAsString: (e) => e.libelle.value,
                            items: (e, f) => ctl.fetchSuccursales(),
                            onChanged: (e) {
                              ctl.succursale = e;
                              ctl.update();
                            },
                            margin: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fade(duration: 350.ms).slideY(begin: 0.05, end: 0),
              ],
            ),
          ),
        );
      },
    );
  }
}
