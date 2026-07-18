import 'package:ateliya/api/mall_api.dart';
import 'package:ateliya/data/models/mall_settings.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';

class MallSettingsVctl extends AuthViewController {
  final _api = MallApi();
  bool loading = true;

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
      libelleCtl, descriptionCtl, emailCtl, numeroCtl,
      promoHeaderBadgeCtl, promoHeaderTitleCtl, promoHeaderSubtitleCtl, promoHeaderDescriptionCtl,
      nouveauHeaderBadgeCtl, nouveauHeaderTitleCtl, nouveauHeaderSubtitleCtl, nouveauHeaderDescriptionCtl,
      whatsappCtl, facebookCtl, instagramCtl, tiktokCtl, twitterCtl, youtubeCtl,
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
    final res = await _api.updateMallSettings({
      'libelle': libelleCtl.text,
      'description': descriptionCtl.text,
      'email': emailCtl.text,
      'numero': numeroCtl.text,
    }).load();
    _handleResponse(res);
  }

  Future<void> savePromo() async {
    final res = await _api.updateMallSettings({
      'mallPromoHeaderBadge': promoHeaderBadgeCtl.text,
      'mallPromoHeaderTitle': promoHeaderTitleCtl.text,
      'mallPromoHeaderSubtitle': promoHeaderSubtitleCtl.text,
      'mallPromoHeaderDescription': promoHeaderDescriptionCtl.text,
    }).load();
    _handleResponse(res);
  }

  Future<void> saveNouveau() async {
    final res = await _api.updateMallSettings({
      'mallNouveauHeaderBadge': nouveauHeaderBadgeCtl.text,
      'mallNouveauHeaderTitle': nouveauHeaderTitleCtl.text,
      'mallNouveauHeaderSubtitle': nouveauHeaderSubtitleCtl.text,
      'mallNouveauHeaderDescription': nouveauHeaderDescriptionCtl.text,
    }).load();
    _handleResponse(res);
  }

  Future<void> saveReseaux() async {
    final res = await _api.updateMallSettings({
      'whatsapp': whatsappCtl.text,
      'facebook': facebookCtl.text,
      'instagram': instagramCtl.text,
      'tiktok': tiktokCtl.text,
      'twitter': twitterCtl.text,
      'youtube': youtubeCtl.text,
    }).load();
    _handleResponse(res);
  }

  void _handleResponse(dynamic res) {
    if (res.status) {
      CSnackbar.show(message: 'Modifications enregistrées', isSuccess: true);
    } else {
      CSnackbar.show(message: res.message);
    }
  }
}
