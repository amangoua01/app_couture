import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_settings.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

class MallSettingsVctl extends AuthViewController {
  final _api = MallApi();
  bool loading = true;
  bool saving = false;

  // Général
  final libelleCtl = TextEditingController();
  final descriptionCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final numeroCtl = TextEditingController();

  // Promotions header
  final promoHeaderBadgeCtl = TextEditingController();
  final promoHeaderTitleCtl = TextEditingController();
  final promoHeaderSubtitleCtl = TextEditingController();
  final promoHeaderDescriptionCtl = TextEditingController();

  // Nouveautés header
  final nouveauHeaderBadgeCtl = TextEditingController();
  final nouveauHeaderTitleCtl = TextEditingController();
  final nouveauHeaderSubtitleCtl = TextEditingController();
  final nouveauHeaderDescriptionCtl = TextEditingController();

  // Réseaux sociaux
  final whatsappCtl = TextEditingController();
  final facebookCtl = TextEditingController();
  final instagramCtl = TextEditingController();
  final tiktokCtl = TextEditingController();
  final twitterCtl = TextEditingController();
  final youtubeCtl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  @override
  void onClose() {
    for (final c in [
      libelleCtl,
      descriptionCtl,
      emailCtl,
      numeroCtl,
      promoHeaderBadgeCtl,
      promoHeaderTitleCtl,
      promoHeaderSubtitleCtl,
      promoHeaderDescriptionCtl,
      nouveauHeaderBadgeCtl,
      nouveauHeaderTitleCtl,
      nouveauHeaderSubtitleCtl,
      nouveauHeaderDescriptionCtl,
      whatsappCtl,
      facebookCtl,
      instagramCtl,
      tiktokCtl,
      twitterCtl,
      youtubeCtl,
    ]) {
      c.dispose();
    }
    super.onClose();
  }

  Future<void> _load() async {
    loading = true;
    update();
    final res = await _api.getMallSettings().load();
    if (res.status) _fillForm(res.data!);
    loading = false;
    update();
  }

  void _fillForm(MallSettings s) {
    libelleCtl.text = s.libelle;
    descriptionCtl.text = s.description;
    emailCtl.text = s.email;
    numeroCtl.text = s.numero;
    promoHeaderBadgeCtl.text = s.mallPromoHeaderBadge;
    promoHeaderTitleCtl.text = s.mallPromoHeaderTitle;
    promoHeaderSubtitleCtl.text = s.mallPromoHeaderSubtitle;
    promoHeaderDescriptionCtl.text = s.mallPromoHeaderDescription;
    nouveauHeaderBadgeCtl.text = s.mallNouveauHeaderBadge;
    nouveauHeaderTitleCtl.text = s.mallNouveauHeaderTitle;
    nouveauHeaderSubtitleCtl.text = s.mallNouveauHeaderSubtitle;
    nouveauHeaderDescriptionCtl.text = s.mallNouveauHeaderDescription;
    whatsappCtl.text = s.whatsapp;
    facebookCtl.text = s.facebook;
    instagramCtl.text = s.instagram;
    tiktokCtl.text = s.tiktok;
    twitterCtl.text = s.twitter;
    youtubeCtl.text = s.youtube;
  }

  Future<void> saveGeneral() async {
    if (libelleCtl.text.trim().isEmpty) {
      CSnackbar.show(message: 'Le nom de la boutique est requis');
      return;
    }
    await _save({
      'libelle': libelleCtl.text.trim(),
      'description': descriptionCtl.text,
      'email': emailCtl.text,
      'numero': numeroCtl.text,
    });
  }

  Future<void> savePromo() async {
    await _save({
      'mallPromoHeaderBadge': promoHeaderBadgeCtl.text,
      'mallPromoHeaderTitle': promoHeaderTitleCtl.text,
      'mallPromoHeaderSubtitle': promoHeaderSubtitleCtl.text,
      'mallPromoHeaderDescription': promoHeaderDescriptionCtl.text,
    });
  }

  Future<void> saveNouveau() async {
    await _save({
      'mallNouveauHeaderBadge': nouveauHeaderBadgeCtl.text,
      'mallNouveauHeaderTitle': nouveauHeaderTitleCtl.text,
      'mallNouveauHeaderSubtitle': nouveauHeaderSubtitleCtl.text,
      'mallNouveauHeaderDescription': nouveauHeaderDescriptionCtl.text,
    });
  }

  Future<void> saveReseaux() async {
    await _save({
      'whatsapp': whatsappCtl.text,
      'facebook': facebookCtl.text,
      'instagram': instagramCtl.text,
      'tiktok': tiktokCtl.text,
      'twitter': twitterCtl.text,
      'youtube': youtubeCtl.text,
    });
  }

  Future<void> _save(Map<String, dynamic> body) async {
    if (saving) return;
    saving = true;
    update();
    final res = await _api.updateMallSettings(body).load();
    saving = false;
    update();
    if (res.status) {
      CSnackbar.show(message: 'Modifications enregistrées', isSuccess: true);
    } else {
      CSnackbar.show(message: res.message);
    }
  }
}
