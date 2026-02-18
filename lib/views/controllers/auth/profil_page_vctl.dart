import 'package:ateliya/api/auth_api.dart';
import 'package:ateliya/api/entreprise_api.dart';
import 'package:ateliya/data/dto/update_profil_dto.dart';
import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/data/models/entreprise.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_bottom_image_picker.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/widgets.dart';

class ProfilPageVctl extends AuthViewController {
  final nomCtl = TextEditingController();
  final prenomCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final nomEntrepriseCtl = TextEditingController();
  final telephoneEntrepriseCtl = TextEditingController();
  final emailEntrepriseCtl = TextEditingController();
  final api = AuthApi();
  final entrepriseApi = EntrepriseApi();
  bool isEntrepriseInfoLoading = false;
  Fichier? logoUserPath, logoEntreprisePath;

  ProfilPageVctl() {
    if (user.photoProfil.value.isNotEmpty) {
      logoUserPath = FichierLocal(path: user.photoProfil.value);
    }

    if (user.entreprise != null) {
      if ((user.entreprise?.logo is FichierServer)) {
        if ((user.entreprise?.logo as FichierServer).path?.isNotEmpty ==
            false) {
          logoEntreprisePath = FichierLocal(
              path: (user.entreprise?.logo as FichierServer).path!);
        }
      }
      nomEntrepriseCtl.text = user.entreprise!.libelle.value;
      telephoneEntrepriseCtl.text = user.entreprise!.numero.value;
      emailEntrepriseCtl.text = user.entreprise!.email.value;
    }
  }

  Future<void> submitProfil() async {
    if (formKey.currentState!.validate()) {
      final dto = UpdateProfilDto(
        id: user.id.value,
        nom: nomCtl.text,
        prenom: prenomCtl.text,
        email: user.login.value,
      );

      final res = await api.updateProfile(dto).load();
      if (res.status) {
        user.nom = dto.nom;
        user.prenoms = dto.prenom;
        user = user;
        update();
        CMessageDialog.show(
          message: "Profil mis à jour avec succès",
          isSuccess: true,
        );
      } else {
        CMessageDialog.show(message: res.message);
      }
    }
  }

  Future<void> submitEntreprise() async {
    if (formKey.currentState!.validate()) {
      final entreprise = Entreprise(
        libelle: nomEntrepriseCtl.text,
        numero: telephoneEntrepriseCtl.text,
        email: emailEntrepriseCtl.text,
        logo: logoEntreprisePath,
      );

      final res = await entrepriseApi.updateEntreprise(entreprise).load();
      if (res.status) {
        // Mettre à jour les données de l'entreprise dans le user
        if (user.entreprise != null) {
          user.entreprise!.libelle = res.data!.libelle;
          user.entreprise!.numero = res.data!.numero;
          user.entreprise!.email = res.data!.email;
          user.entreprise!.logo = res.data!.logo;
        } else {
          user.entreprise = res.data;
        }
        user = user;
        logoEntreprisePath = null; // Réinitialiser le chemin du logo
        update();
        CMessageDialog.show(
          message: "Entreprise mise à jour avec succès",
          isSuccess: true,
        );
      } else {
        CMessageDialog.show(message: res.message);
      }
    }
  }

  Future<void> pickUserLogo() async {
    try {
      final file = await CBottomImagePicker.show(cropImage: true);
      if (file != null) {
        logoUserPath = FichierLocal.fromFile(file);
        update();
      }
    } catch (e) {
      CMessageDialog.show(message: "Erreur lors de la sélection du logo: $e");
    }
  }

  Future<void> pickEntrepriseLogo() async {
    try {
      final file = await CBottomImagePicker.show(cropImage: true);
      if (file != null) {
        logoEntreprisePath = FichierLocal.fromFile(file);
        update();
      }
    } catch (e) {
      CMessageDialog.show(message: "Erreur lors de la sélection du logo: $e");
    }
  }

  @override
  void onInit() {
    nomCtl.text = user.nom.value;
    prenomCtl.text = user.prenoms.value;
    super.onInit();
  }
}
