import 'package:ateliya/data/models/assistant/assistant_balance.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/views/controllers/assistant/assistant_packs_page_vctl.dart';
import 'package:ateliya/views/static/assistant/assistant_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Achat de tokens : choix du pack, du moyen de paiement et du numéro.
class AssistantPacksPage extends StatelessWidget {
  final AssistantBalance balance;
  const AssistantPacksPage({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssistantPacksPageVctl>(
      init: AssistantPacksPageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
            scrolledUnderElevation: 0,
            title: const Text("Recharger des tokens", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          body: _body(ctl),
        );
      },
    );
  }

  Widget _body(AssistantPacksPageVctl ctl) {
    if (ctl.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (ctl.loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ctl.loadError!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 12),
              TextButton(onPressed: ctl.load, child: const Text("Réessayer")),
            ],
          ),
        ),
      );
    }

    final waiting = ctl.paymentState == PackPaymentState.waiting;
    final success = ctl.paymentState == PackPaymentState.success;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _balanceCard(),
        const SizedBox(height: 18),
        if (ctl.paymentState != PackPaymentState.idle && ctl.paymentState != PackPaymentState.paying)
          _statusCard(ctl),
        if (!success) ...[
          _sectionTitle("Choisissez un pack"),
          if (ctl.packs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Aucun pack n'est disponible pour le moment.",
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          for (final p in ctl.packs)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _packTile(ctl, p, enabled: !waiting),
            ),
          if (ctl.packs.isNotEmpty) ...[
            const SizedBox(height: 14),
            _sectionTitle("Moyen de paiement"),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final o in ctl.operateurs)
                  ChoiceChip(
                    label: Text(o.libelle ?? o.code ?? "Opérateur"),
                    selected: ctl.selectedOperateur?.id == o.id,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: ctl.selectedOperateur?.id == o.id ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    onSelected: waiting ? null : (_) => ctl.selectOperateur(o),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            _sectionTitle("Numéro de paiement"),
            TextField(
              controller: ctl.phoneCtl,
              enabled: !waiting,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))],
              onChanged: (_) => ctl.update(),
              decoration: InputDecoration(
                hintText: "Numéro Mobile Money",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: ctl.canPay ? ctl.pay : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.ligthGrey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: ctl.paymentState == PackPaymentState.paying
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : Text(
                        ctl.selectedPack == null ? "Payer" : "Payer ${formatXof(ctl.selectedPack!.montant)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: ctl.canPay ? Colors.white : AppColors.textMuted,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Les tokens achetés n'expirent pas. Ils servent après le quota inclus dans votre forfait.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.4),
            ),
          ],
        ],
      ],
    );
  }

  Widget _balanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(AppIconsBold.sparkle, color: AppColors.secondary, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${balance.soldeTotal} tokens",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
                ),
                const SizedBox(height: 3),
                Text(
                  "${balance.soldeForfait} du forfait, ${balance.soldePacks} achetés"
                  "${balance.prochainRenouvellement != null ? '. Quota remis à zéro le ${formatDate(balance.prochainRenouvellement!)}' : ''}",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: AppColors.textMuted),
      ),
    );
  }

  Widget _packTile(AssistantPacksPageVctl ctl, pack, {required bool enabled}) {
    final selected = ctl.selectedPack?.id == pack.id;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: enabled ? () => ctl.selectPack(pack) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.10),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: selected ? AppColors.primary : AppColors.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pack.libelle,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${pack.tokens} tokens, environ ${pack.messages} messages",
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Text(
                formatXof(pack.montant),
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard(AssistantPacksPageVctl ctl) {
    final state = ctl.paymentState;
    final ok = state == PackPaymentState.success;
    final failed = state == PackPaymentState.failed;
    final color = ok ? AppColors.primary : (failed ? AppColors.danger : AppColors.secondary);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (state == PackPaymentState.waiting)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.secondary),
                )
              else
                Icon(ok ? Icons.check_circle_rounded : Icons.error_outline_rounded, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  state == PackPaymentState.waiting ? "En attente de confirmation" : (ok ? "Paiement confirmé" : "Paiement non abouti"),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark),
                ),
              ),
            ],
          ),
          if (ctl.paymentMessage != null) ...[
            const SizedBox(height: 6),
            Text(ctl.paymentMessage!, style: const TextStyle(fontSize: 12.5, height: 1.4, color: AppColors.textMuted)),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              if (state == PackPaymentState.waiting)
                _action("J'ai payé", ctl.checkNow, filled: true),
              if (ok) ...[
                _action("Retour au chat", () => Get.back(result: true), filled: true),
              ],
              if (failed || state == PackPaymentState.waiting) ...[
                const SizedBox(width: 8),
                _action(failed ? "Réessayer" : "Annuler", ctl.reset),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(String label, VoidCallback onTap, {bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.transparent,
          border: filled ? null : Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
            color: filled ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
