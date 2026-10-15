import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/reservation.dart';
import 'package:ateliya/tools/components/field_popup.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/constants/reservation_statut.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/photo_produit.dart';
import 'package:ateliya/views/controllers/reservation/reservation_detail_vctl.dart';
import 'package:ateliya/views/static/reservation/reservation_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ReservationDetailPage extends StatelessWidget {
  final int reservationId;
  final Reservation? initiale;
  const ReservationDetailPage(this.reservationId, {this.initiale, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ReservationDetailVctl(reservationId, initiale: initiale),
      builder: (ctl) {
        final r = ctl.reservation;
        return PopScope(
          // Le retour transmet à la liste si quelque chose a changé.
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) Get.back(result: ctl.modifiee);
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAF9),
            appBar: AppBar(title: Text('Réservation n° $reservationId')),
            body:
                r == null
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                      onRefresh: () => ctl.charger(silencieux: true),
                      color: AppColors.secondary,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        children: [
                          _EnTete(reservation: r),
                          if (r.statut.manqueDeStock) ...[
                            const Gap(12),
                            const _AlerteStock(),
                          ],
                          if (r.statut == ReservationStatut.annulee &&
                              (r.cancellationReason ?? '').isNotEmpty) ...[
                            const Gap(12),
                            _MotifAnnulation(motif: r.cancellationReason!),
                          ],
                          const Gap(20),
                          const _Titre('Articles réservés'),
                          for (final l in r.lignes) _LigneArticle(ligne: l),
                          if (r.lignes.isEmpty)
                            Text(
                              'Le détail des articles n\'est pas disponible.',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          const Gap(20),
                          const _Titre('Paiement'),
                          _BlocPaiement(reservation: r),
                          if (r.historique.isNotEmpty) ...[
                            const Gap(20),
                            const _Titre('Historique'),
                            _Historique(etapes: r.historique),
                          ],
                        ],
                      ),
                    ),
            bottomNavigationBar:
                r == null ? null : _BarreActions(ctl: ctl, r: r),
          ),
        );
      },
    );
  }
}

// ─── Blocs ─────────────────────────────────────────────────────────────────────

class _Titre extends StatelessWidget {
  final String label;
  const _Titre(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: AppColors.primary.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

BoxDecoration _carte() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18),
  boxShadow: [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.07),
      blurRadius: 14,
      offset: const Offset(0, 4),
    ),
  ],
);

class _EnTete extends StatelessWidget {
  final Reservation reservation;
  const _EnTete({required this.reservation});

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    final delai = DelaiRetrait.de(r);
    final nom = r.client?.fullName.trim() ?? '';
    final tel = r.client?.tel ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _carte(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatutChip(r.statut, grand: true),
              const Spacer(),
              Text(
                'Créée le ${r.createdAt.toFrenchDate}',
                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
              ),
            ],
          ),
          const Gap(14),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  nom.isEmpty ? '?' : nom[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nom.isEmpty ? 'Client inconnu' : nom,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    if (tel.isNotEmpty)
                      Text(
                        tel,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              if (tel.isNotEmpty)
                IconButton.filledTonal(
                  tooltip: 'Appeler',
                  onPressed: () => launchUrl(Uri(scheme: 'tel', path: tel)),
                  icon: const Icon(Icons.call_rounded, size: 20),
                ),
            ],
          ),
          if (delai != null) ...[
            const Gap(14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: delai.couleur.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_rounded, size: 18, color: delai.couleur),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      '${delai.libelle} · ${r.dateRetrait.toFrenchDate}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: delai.couleur,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AlerteStock extends StatelessWidget {
  const _AlerteStock();

  @override
  Widget build(BuildContext context) {
    const couleur = Color(0xFFC2410C);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.inventory_2_outlined, size: 20, color: couleur),
          Gap(10),
          Expanded(
            child: Text(
              'Le stock est insuffisant pour au moins un article. Ravitaillez la boutique, puis confirmez la réservation.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: couleur,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MotifAnnulation extends StatelessWidget {
  final String motif;
  const _MotifAnnulation({required this.motif});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        'Motif d\'annulation : $motif',
        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
      ),
    );
  }
}

class _LigneArticle extends StatelessWidget {
  final ReservationLigne ligne;
  const _LigneArticle({required this.ligne});

  @override
  Widget build(BuildContext context) {
    final mb = ligne.modele;
    final photo = mb?.modele?.photo;
    final url = photo is FichierServer ? photo.fullUrl : null;
    final taille = (mb?.taille ?? '').isEmpty ? null : mb!.taille;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: _carte(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 58,
              height: 58,
              child: PhotoProduit(
                url: url,
                largeurAffichee: 58,
                placeholder: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset('assets/images/model1.png'),
                ),
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mb?.modele?.libelle ?? 'Article',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  [
                    if (taille != null) 'Taille $taille',
                    '${ligne.quantite ?? 1} × ${montantF(mb?.prix.toDouble().value ?? 0)}',
                  ].join(' · '),
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            montantF(ligne.total),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlocPaiement extends StatelessWidget {
  final Reservation reservation;
  const _BlocPaiement({required this.reservation});

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    final solde = r.resteValue <= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _carte(),
      child: Column(
        children: [
          ProgressionPaiement(r),
          const Gap(14),
          _Ligne('Montant total', montantF(r.montantValue)),
          const Gap(8),
          _Ligne('Déjà versé', montantF(r.avanceValue)),
          const Divider(height: 24),
          _Ligne(
            solde ? 'Réservation soldée' : 'Reste à payer',
            solde ? '✓' : montantF(r.resteValue),
            fort: true,
            couleur: solde ? AppColors.green : AppColors.secondary,
          ),
          if (r.versements.isNotEmpty) ...[
            const Gap(16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Versements',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const Gap(8),
            for (final v in r.versements)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.south_west_rounded,
                      size: 16,
                      color: AppColors.green,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        '${v.createdAt.toFrenchDate} · ${v.moyenPaiement ?? ''}',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Text(
                      montantF(v.montant.toDouble().value),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Ligne extends StatelessWidget {
  final String libelle;
  final String valeur;
  final bool fort;
  final Color? couleur;
  const _Ligne(this.libelle, this.valeur, {this.fort = false, this.couleur});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            libelle,
            style: TextStyle(
              fontSize: fort ? 14.5 : 13.5,
              fontWeight: fort ? FontWeight.w800 : FontWeight.w500,
              color: fort ? AppColors.primary : Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          valeur,
          style: TextStyle(
            fontSize: fort ? 17 : 14,
            fontWeight: FontWeight.w800,
            color: couleur ?? AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _Historique extends StatelessWidget {
  final List<ReservationEtape> etapes;
  const _Historique({required this.etapes});

  @override
  Widget build(BuildContext context) {
    final liste = etapes.reversed.toList();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: _carte(),
      child: Column(
        children: [
          for (var i = 0; i < liste.length; i++)
            _EtapeHistorique(etape: liste[i], derniere: i == liste.length - 1),
        ],
      ),
    );
  }
}

class _EtapeHistorique extends StatelessWidget {
  final ReservationEtape etape;
  final bool derniere;
  const _EtapeHistorique({required this.etape, required this.derniere});

  @override
  Widget build(BuildContext context) {
    final statut = ReservationStatut.fromCode(etape.nouveau);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: statut.color,
                  shape: BoxShape.circle,
                ),
              ),
              if (!derniere)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade200),
                ),
            ],
          ),
          const Gap(12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statut.label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: statut.color,
                    ),
                  ),
                  Text(
                    etape.date.toFrenchDateTime,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  if ((etape.motif ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        etape.motif!,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Actions ───────────────────────────────────────────────────────────────────

class _BarreActions extends StatelessWidget {
  final ReservationDetailVctl ctl;
  final Reservation r;
  const _BarreActions({required this.ctl, required this.r});

  @override
  Widget build(BuildContext context) {
    final statut = r.statut;
    final peutVerser = statut.peutRecevoirVersement && r.resteValue > 0;
    if (!statut.peutConfirmer && !peutVerser) return const SizedBox.shrink();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (peutVerser)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _verser(context),
                      icon: const Icon(Icons.payments_outlined, size: 19),
                      label: const Text('Versement'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(0, 50),
                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.35),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                if (peutVerser && statut.peutConfirmer) const Gap(10),
                if (statut.peutConfirmer)
                  Expanded(
                    flex: 3,
                    child: FilledButton.icon(
                      onPressed: () => _confirmer(context),
                      icon: const Icon(Icons.check_rounded, size: 20),
                      label: const Text('Confirmer'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (statut.peutAnnuler)
              TextButton(
                onPressed: () => _annuler(context),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFB91C1C),
                ),
                child: const Text('Annuler la réservation'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmer(BuildContext context) async {
    final ok = await CChoiceMessageDialog.show(
      title: 'Confirmer la réservation',
      message:
          'Le stock des articles sera déduit. Cette action ne peut pas être annulée.',
      validText: 'Confirmer',
      cancelText: 'Retour',
      height: 140,
    );
    if (ok == true) await ctl.confirmer();
  }

  Future<void> _verser(BuildContext context) async {
    final res = await showModalBottomSheet<_Versement>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _VersementSheet(reste: r.resteValue.round()),
    );
    if (res != null) await ctl.verser(res.montant, res.moyen);
  }

  Future<void> _annuler(BuildContext context) async {
    final res = await showModalBottomSheet<_Annulation>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const _AnnulationSheet(),
    );
    if (res != null) await ctl.annuler(motif: res.motif);
  }
}

class _Versement {
  final int montant;
  final String moyen;
  const _Versement(this.montant, this.moyen);
}

class _Annulation {
  final String motif;
  const _Annulation(this.motif);
}

class _VersementSheet extends StatefulWidget {
  final int reste;
  const _VersementSheet({required this.reste});

  @override
  State<_VersementSheet> createState() => _VersementSheetState();
}

class _VersementSheetState extends State<_VersementSheet> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _montant = TextEditingController(
    text: '${widget.reste}',
  );
  String _moyen = ModePaiementEnum.especes.label;

  @override
  void dispose() {
    _montant.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encaisser un versement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const Gap(4),
            Text(
              'Reste à payer : ${montantF(widget.reste.toDouble())}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Gap(18),
            CTextFormField(
              controller: _montant,
              externalLabel: 'Montant versé',
              keyboardType: TextInputType.number,
              require: true,
              validator: (e) {
                final v = int.tryParse(e ?? '');
                if (v == null || v <= 0) return 'Saisissez un montant valide';
                if (v > widget.reste) {
                  return 'Maximum : ${montantF(widget.reste.toDouble())}';
                }
                return null;
              },
            ),
            CDropDownFormField<String>(
              externalLabel: 'Moyen de paiement',
              require: true,
              showClearButton: false,
              selectedItem: _moyen,
              items:
                  (f, p) =>
                      ModePaiementEnum.values.map((e) => e.label).toList(),
              popupProps: FieldPopup.bottomSheet<String>(
                title: 'Moyen de paiement',
                showSearchBox: false,
              ),
              onChanged: (v) => setState(() => _moyen = v ?? _moyen),
            ),
            const Gap(6),
            FilledButton(
              onPressed: () {
                if (_form.currentState!.validate()) {
                  Navigator.pop(
                    context,
                    _Versement(int.parse(_montant.text), _moyen),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Enregistrer le versement',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnulationSheet extends StatefulWidget {
  const _AnnulationSheet();

  @override
  State<_AnnulationSheet> createState() => _AnnulationSheetState();
}

class _AnnulationSheetState extends State<_AnnulationSheet> {
  final _motif = TextEditingController();

  @override
  void dispose() {
    _motif.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Annuler la réservation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFFB91C1C),
            ),
          ),
          const Gap(4),
          Text(
            'Le client sera prévenu de l\'annulation si le serveur le prévoit. Cette action est définitive.',
            style: TextStyle(color: Colors.grey.shade600, height: 1.35),
          ),
          const Gap(18),
          CTextFormField(
            controller: _motif,
            externalLabel: 'Motif (facultatif)',
            hintText: 'Ex : le client a changé d\'avis',
            maxLines: 3,
          ),
          FilledButton(
            onPressed:
                () => Navigator.pop(context, _Annulation(_motif.text.trim())),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB91C1C),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Annuler la réservation',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
