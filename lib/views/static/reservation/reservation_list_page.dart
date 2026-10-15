import 'package:ateliya/data/models/reservation.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/onglets_compteurs.dart';
import 'package:ateliya/views/controllers/reservation/reservation_list_vctl.dart';
import 'package:ateliya/views/static/reservation/reservation_detail_page.dart';
import 'package:ateliya/views/static/reservation/reservation_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReservationListPage extends StatelessWidget {
  const ReservationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ReservationListVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAF9),
          appBar: AppBar(title: const Text('Réservations')),
          body: Column(
            children: [
              const Gap(12),
              if (ctl.hasLoadedOnce)
                OngletsCompteurs<ReservationOnglet>(
                  selection: ctl.onglet,
                  onChanged: ctl.choisir,
                  onglets: [
                    OngletCompteur(
                      valeur: ReservationOnglet.aTraiter,
                      libelle: 'À traiter',
                      nombre: ctl.compte(ReservationOnglet.aTraiter),
                      accent: const Color(0xFFB7791F),
                    ),
                    OngletCompteur(
                      valeur: ReservationOnglet.confirmees,
                      libelle: 'Confirmées',
                      nombre: ctl.compte(ReservationOnglet.confirmees),
                    ),
                    OngletCompteur(
                      valeur: ReservationOnglet.annulees,
                      libelle: 'Annulées',
                      nombre: ctl.compte(ReservationOnglet.annulees),
                    ),
                    OngletCompteur(
                      valeur: ReservationOnglet.toutes,
                      libelle: 'Toutes',
                      nombre: ctl.compte(ReservationOnglet.toutes),
                    ),
                  ],
                ),
              if (ctl.nbManqueStock > 0 &&
                  ctl.onglet == ReservationOnglet.aTraiter)
                _BandeauStock(nombre: ctl.nbManqueStock),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  transitionBuilder:
                      (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.025),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                  child: KeyedSubtree(
                    key: ValueKey((ctl.onglet, ctl.hasLoadedOnce)),
                    child:
                        !ctl.hasLoadedOnce
                            ? const Center(child: CircularProgressIndicator())
                            : RefreshIndicator(
                              onRefresh: ctl.fetch,
                              color: AppColors.secondary,
                              child:
                                  ctl.affichees.isEmpty
                                      ? ListView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        children: [_Vide(onglet: ctl.onglet)],
                                      )
                                      : ListView.separated(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          4,
                                          16,
                                          32,
                                        ),
                                        itemCount: ctl.affichees.length,
                                        separatorBuilder:
                                            (_, __) => const Gap(12),
                                        itemBuilder:
                                            (context, i) => _CarteReservation(
                                              reservation: ctl.affichees[i],
                                              onTap: () async {
                                                final modifiee = await Get.to(
                                                  () => ReservationDetailPage(
                                                    ctl.affichees[i].id!,
                                                    initiale: ctl.affichees[i],
                                                  ),
                                                );
                                                if (modifiee == true)
                                                  ctl.fetch();
                                              },
                                            ),
                                      ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BandeauStock extends StatelessWidget {
  final int nombre;
  const _BandeauStock({required this.nombre});

  @override
  Widget build(BuildContext context) {
    const couleur = Color(0xFFC2410C);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined, size: 18, color: couleur),
          const Gap(10),
          Expanded(
            child: Text(
              nombre == 1
                  ? '1 réservation attend du stock avant de pouvoir être confirmée.'
                  : '$nombre réservations attendent du stock avant de pouvoir être confirmées.',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: couleur,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarteReservation extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onTap;
  const _CarteReservation({required this.reservation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = reservation;
    final delai = DelaiRetrait.de(r);
    final nom = r.client?.fullName.trim() ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 19,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        nom.isEmpty ? '?' : nom[0].toUpperCase(),
                        style: const TextStyle(
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            resumeArticles(r),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    StatutChip(r.statut),
                  ],
                ),
                const Gap(12),
                ProgressionPaiement(r),
                const Gap(8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Avancé ${montantF(r.avanceValue)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Text(
                      r.resteValue <= 0
                          ? 'Soldée'
                          : 'Reste ${montantF(r.resteValue)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color:
                            r.resteValue <= 0
                                ? AppColors.green
                                : AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                if (delai != null) ...[
                  const Gap(10),
                  Row(
                    children: [
                      Icon(Icons.event_rounded, size: 15, color: delai.couleur),
                      const Gap(6),
                      Text(
                        delai.libelle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: delai.couleur,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Vide extends StatelessWidget {
  final ReservationOnglet onglet;
  const _Vide({required this.onglet});

  @override
  Widget build(BuildContext context) {
    final texte = switch (onglet) {
      ReservationOnglet.aTraiter => 'Rien à traiter pour le moment',
      ReservationOnglet.confirmees => 'Aucune réservation confirmée',
      ReservationOnglet.annulees => 'Aucune réservation annulée',
      ReservationOnglet.toutes => 'Aucune réservation',
    };
    return Padding(
      padding: const EdgeInsets.only(top: 90, left: 32, right: 32),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 54,
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
          const Gap(14),
          Text(
            texte,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const Gap(6),
          Text(
            'Pour réserver, ouvrez un article depuis la boutique et touchez « Réserver ».',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
