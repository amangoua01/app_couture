import 'dart:async';

import 'package:ateliya/api/assistant_api.dart';
import 'package:ateliya/api/operateur_api.dart';
import 'package:ateliya/data/models/assistant/token_pack.dart';
import 'package:ateliya/data/models/operateur.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum PackPaymentState { idle, paying, waiting, success, failed }

class AssistantPacksPageVctl extends AuthViewController {
  /// Fréquence et durée du suivi du paiement après l'ouverture du navigateur.
  static const _pollEvery = Duration(seconds: 4);
  static const _pollFor = Duration(minutes: 3);

  final api = AssistantApi();
  final phoneCtl = TextEditingController();

  List<TokenPack> packs = [];
  List<Operateur> operateurs = [];
  TokenPack? selectedPack;
  Operateur? selectedOperateur;
  bool isLoading = true;
  String? loadError;

  PackPaymentState paymentState = PackPaymentState.idle;
  String? paymentMessage;
  String? _reference;
  Timer? _timer;
  DateTime? _pollUntil;

  bool get canPay =>
      selectedPack != null &&
      selectedOperateur != null &&
      phoneCtl.text.trim().length >= 8 &&
      paymentState != PackPaymentState.paying &&
      paymentState != PackPaymentState.waiting;

  @override
  void onReady() {
    load();
    super.onReady();
  }

  Future<void> load() async {
    isLoading = true;
    loadError = null;
    update();

    final results = await Future.wait([api.packs(), OperateurApi().list()]);
    final packsRes = results[0] as dynamic;
    final opsRes = results[1] as dynamic;

    if (packsRes.status) {
      packs = packsRes.data as List<TokenPack>;
      selectedPack ??= packs.length > 1 ? packs[1] : packs.firstOrNull;
    } else {
      loadError = packsRes.message as String;
    }
    if (opsRes.status) {
      operateurs = (opsRes.data as List)
          .map((e) => Operateur.fromJson(e as Map<String, dynamic>))
          .where((o) => o.isActive != false)
          .toList();
      selectedOperateur ??= operateurs.firstOrNull;
    }
    isLoading = false;
    update();
  }

  void selectPack(TokenPack pack) {
    selectedPack = pack;
    update();
  }

  void selectOperateur(Operateur operateur) {
    selectedOperateur = operateur;
    update();
  }

  Future<void> pay() async {
    if (!canPay) return;
    paymentState = PackPaymentState.paying;
    paymentMessage = null;
    update();

    final res = await api.purchase(
      packId: selectedPack!.id,
      operateurId: selectedOperateur!.id.value,
      email: user.login.value,
      numero: phoneCtl.text.trim(),
    );

    if (!res.status) {
      paymentState = PackPaymentState.failed;
      paymentMessage = res.message;
      update();
      return;
    }

    _reference = res.data!.reference;
    paymentState = PackPaymentState.waiting;
    paymentMessage = "Terminez le paiement dans la page ouverte, puis revenez ici.";
    update();

    final opened = await launchUrl(
      Uri.parse(res.data!.redirectUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!opened) {
      paymentMessage = "Impossible d'ouvrir la page de paiement. Réessayez.";
      paymentState = PackPaymentState.failed;
      update();
      return;
    }
    _startPolling();
  }

  /// Vérification manuelle (bouton « J'ai payé »).
  Future<void> checkNow() => _check();

  void _startPolling() {
    _timer?.cancel();
    _pollUntil = DateTime.now().add(_pollFor);
    _timer = Timer.periodic(_pollEvery, (_) => _check());
  }

  Future<void> _check() async {
    final reference = _reference;
    if (reference == null) return;

    final res = await api.purchaseStatus(reference);
    if (res.status) {
      switch (res.data) {
        case 'success':
          _stop(PackPaymentState.success, "Paiement confirmé : vos tokens sont crédités.");
          return;
        case 'failed':
          _stop(PackPaymentState.failed, "Le paiement a échoué ou a été annulé. Aucun montant n'a été débité.");
          return;
      }
    }
    if (_pollUntil != null && DateTime.now().isAfter(_pollUntil!)) {
      _timer?.cancel();
      paymentMessage =
          "Le paiement n'est pas encore confirmé. Si vous avez payé, touchez « J'ai payé » dans quelques instants.";
      update();
    }
  }

  void _stop(PackPaymentState state, String message) {
    _timer?.cancel();
    paymentState = state;
    paymentMessage = message;
    update();
  }

  /// Revient à l'état initial pour acheter un autre pack après un succès ou un échec.
  void reset() {
    _timer?.cancel();
    _reference = null;
    paymentState = PackPaymentState.idle;
    paymentMessage = null;
    update();
  }

  @override
  void onClose() {
    _timer?.cancel();
    phoneCtl.dispose();
    super.onClose();
  }
}
