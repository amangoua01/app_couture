import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/stock_modele_item.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/main_app_bar.dart';
import 'package:ateliya/tools/widgets/onglets_compteurs.dart';
import 'package:ateliya/tools/widgets/photo_produit.dart';
import 'package:ateliya/tools/widgets/preview_image_page.dart';
import 'package:ateliya/views/controllers/home/boutique_page_vctl.dart';
import 'package:ateliya/views/static/home/detail_boutique_item_page.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/page_boutique/boutique_skeleton.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/page_boutique/search_bar_part.dart';
import 'package:ateliya/views/static/ravitaillement/edition_ravitaillement_page.dart';
import 'package:ateliya/views/static/reservation/edition_reservation_page.dart';
import 'package:ateliya/views/static/stocks/edition_sortie_stock_page.dart';
import 'package:ateliya/views/static/ventes/edition_vente_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BoutiquePage extends StatelessWidget {
  const BoutiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BoutiquePageVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAF9),
          appBar: MainAppBar(
            notifCount: ctl.nbUnreadNotifs,
            onSelectionChanged: () => ctl.fetchData(),
            onNotifRefresh: () => ctl.loadUnreadCount(),
          ),
          body: Column(
            children: [
              SearchBarPart(ctl: ctl),
              if (ctl.hasLoadedOnce && ctl.nbTous > 0) _FiltresStock(ctl: ctl),
              Expanded(
                // Tant qu'aucune lecture n'a abouti, on montre la silhouette du
                // contenu : annoncer une boutique vide avant d'avoir interrogé
                // le serveur obligeait l'utilisateur à actualiser à la main.
                // Changer de filtre, ou passer du chargement aux données, se
                // fait en fondu avec un léger glissement : le contenu ne
                // saute plus d'un coup.
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeIn,
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
                    key: ValueKey((
                      ctl.filtre,
                      ctl.isLoading || !ctl.hasLoadedOnce,
                    )),
                    child:
                        (ctl.isLoading || !ctl.hasLoadedOnce)
                            ? const BoutiqueSkeleton()
                            : ctl.data.isEmpty
                            ? RefreshIndicator(
                              onRefresh: ctl.fetchData,
                              color: AppColors.secondary,
                              child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height: 460,
                                    child:
                                        ctl.hasQuery
                                            ? BoutiqueAucunResultat(
                                              onEffacer: ctl.clearSearch,
                                            )
                                            : BoutiqueVide(
                                              onRavitailler:
                                                  ctl.user.isAdmin
                                                      ? () async {
                                                        final res = await Get.to(
                                                          () =>
                                                              const EditionRavitaillementPage(),
                                                        );
                                                        if (res != null) {
                                                          ctl.fetchData();
                                                        }
                                                      }
                                                      : null,
                                            ),
                                  ),
                                ],
                              ),
                            )
                            : RefreshIndicator(
                              onRefresh: ctl.fetchData,
                              color: AppColors.secondary,
                              // Une seule grille paresseuse : seules les cartes
                              // visibles sont construites, quel que soit le
                              // nombre de modèles.
                              child: GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  110,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.7,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                    ),
                                itemCount: ctl.data.length,
                                itemBuilder:
                                    (context, i) => _ModeleCard(
                                      item: ctl.data[i],
                                      onTap:
                                          () => _ouvrirVariantes(
                                            context,
                                            ctl,
                                            ctl.data[i],
                                          ),
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

  void _ouvrirVariantes(
    BuildContext context,
    BoutiquePageVctl ctl,
    StockModeleItem item,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VariantesSheet(item: item, ctl: ctl),
    );
  }
}

// ─── Filtres rapides ───────────────────────────────────────────────────────────

class _FiltresStock extends StatelessWidget {
  final BoutiquePageVctl ctl;
  const _FiltresStock({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return OngletsCompteurs<StockFiltre>(
      selection: ctl.filtre,
      onChanged: ctl.setFiltre,
      onglets: [
        OngletCompteur(
          valeur: StockFiltre.tous,
          libelle: 'Tous',
          nombre: ctl.nbTous,
        ),
        OngletCompteur(
          valeur: StockFiltre.enStock,
          libelle: 'En stock',
          nombre: ctl.nbEnStock,
          accent: AppColors.green,
        ),
        OngletCompteur(
          valeur: StockFiltre.stockBas,
          libelle: 'Stock bas',
          nombre: ctl.nbStockBas,
          accent: AppColors.secondary,
        ),
        OngletCompteur(
          valeur: StockFiltre.rupture,
          libelle: 'Rupture',
          nombre: ctl.nbRupture,
          accent: AppColors.danger,
        ),
      ],
    );
  }
}

// ─── Carte modèle ──────────────────────────────────────────────────────────────

/// Fourchette de prix des variantes : « 30 000 F » ou « 25 000 – 32 000 F ».
String _fourchettePrix(StockModeleItem item) {
  final prix =
      item.variantes
          .where((v) => v.prix != null)
          .map((v) => v.prix.toStrictDouble())
          .toList()
        ..sort();
  if (prix.isEmpty) return '-';
  if (prix.first == prix.last) return prix.first.toAmount(unit: 'F');
  return '${prix.first.toAmount()} – ${prix.last.toAmount(unit: 'F')}';
}

String? _urlPhoto(StockModeleItem item) {
  final photo = item.modele?.photo;
  return photo is FichierServer ? photo.fullUrl : null;
}

class _ModeleCard extends StatelessWidget {
  final StockModeleItem item;
  final VoidCallback onTap;
  const _ModeleCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final qty = item.quantiteBoutique;
    final rupture = qty <= 0;
    final bas = !rupture && qty <= BoutiquePageVctl.seuilStockBas;
    final tailles =
        item.bilan.parTaille.entries
            .where((e) => e.key.isNotEmpty && e.key != 'N/A')
            .toList();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: PhotoProduit(
                        url: _urlPhoto(item),
                        // Deux colonnes : la vignette fait environ la moitié
                        // de la largeur de l'écran.
                        largeurAffichee: MediaQuery.sizeOf(context).width / 2,
                        placeholder: Container(
                          color: const Color(0xFFF2F4F3),
                          padding: const EdgeInsets.all(28),
                          child: Image.asset('assets/images/model1.png'),
                        ),
                      ),
                    ),
                    if (item.variantes.length > 1)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${item.variantes.length} variantes',
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    if (_urlPhoto(item) != null)
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: _BoutonOeil(url: _urlPhoto(item)!),
                      ),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (rupture || bas)
                                  ? AppColors.secondary
                                  : AppColors.primary.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          rupture
                              ? 'Rupture'
                              : bas
                              ? '$qty · stock bas'
                              : '$qty en stock',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.modele?.libelle ?? 'Sans nom',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const Gap(1),
                    Text(
                      _fourchettePrix(item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                      ),
                    ),
                    if (tailles.isNotEmpty) ...[
                      const Gap(6),
                      SizedBox(
                        height: 18,
                        child: Wrap(
                          spacing: 4,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            for (final t in tailles.take(3))
                              _MiniChip(
                                '${t.key} ${t.value}',
                                vide: t.value <= 0,
                              ),
                            if (tailles.length > 3)
                              _MiniChip('+${tailles.length - 3}', vide: true),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final bool vide;
  const _MiniChip(this.label, {this.vide = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          color: vide ? Colors.grey.shade500 : Colors.black87,
        ),
      ),
    );
  }
}

// ─── Feuille des variantes ─────────────────────────────────────────────────────

class _VariantesSheet extends StatelessWidget {
  final StockModeleItem item;
  final BoutiquePageVctl ctl;
  const _VariantesSheet({required this.item, required this.ctl});

  /// Ferme la feuille avant d'ouvrir l'action : au retour, la feuille ne
  /// resterait sinon affichée qu'avec le stock d'avant l'opération.
  ///
  /// [toucheLeStock] : une réservation ne modifie pas le stock avant sa
  /// confirmation, inutile alors de recharger tout le stock : seul le badge
  /// des réservations se met à jour.
  Future<void> _agir(
    BuildContext context,
    Future<Object?>? Function() action, {
    bool toucheLeStock = true,
  }) async {
    Navigator.of(context).pop();
    final res = await action();
    if (res == null) return;
    if (toucheLeStock) {
      ctl.fetchData();
    } else {
      ctl.chargerReservations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final variantes = item.variantes;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(14),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: PhotoProduit(
                      url: _urlPhoto(item),
                      largeurAffichee: 52,
                      placeholder: Padding(
                        padding: const EdgeInsets.all(10),
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
                        item.modele?.libelle ?? 'Sans nom',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${item.quantiteBoutique} en stock · ${_fourchettePrix(item)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_urlPhoto(item) != null)
                  _BoutonOeil(url: _urlPhoto(item)!, sombre: true),
              ],
            ),
            const Gap(8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: variantes.length,
                separatorBuilder:
                    (_, __) => Divider(height: 1, color: Colors.grey.shade100),
                itemBuilder:
                    (context, i) => _LigneVariante(
                      variante: variantes[i],
                      admin: ctl.user.isAdmin,
                      onVendre:
                          () => _agir(
                            context,
                            () => Get.to(() => EditionVentePage(variantes[i])),
                          ),
                      onReserver:
                          () => _agir(
                            context,
                            () => Get.to(
                              () => EditionReservationPage(variantes[i]),
                            ),
                            toucheLeStock: false,
                          ),
                      onDetails: () {
                        Navigator.of(context).pop();
                        Get.to(() => DetailBoutiqueItemPage(variantes[i]));
                      },
                      onSortie:
                          () => _agir(
                            context,
                            () => Get.to(
                              () => EditionSortieStockPage.one(variantes[i]),
                            ),
                          ),
                      onRavitailler:
                          () => _agir(
                            context,
                            () => Get.to(
                              () => EditionRavitaillementPage.one(variantes[i]),
                            ),
                          ),
                    ),
              ),
            ),
            if (variantes.length == 1) ...[
              const Gap(12),
              _BoutonVente(
                enabled: (variantes.first.quantite ?? 0) > 0,
                large: true,
                onTap:
                    () => _agir(
                      context,
                      () => Get.to(() => EditionVentePage(variantes.first)),
                    ),
              ),
              const Gap(8),
              _BoutonReserver(
                onTap:
                    () => _agir(
                      context,
                      () =>
                          Get.to(() => EditionReservationPage(variantes.first)),
                      toucheLeStock: false,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LigneVariante extends StatelessWidget {
  final ModeleBoutique variante;
  final bool admin;
  final VoidCallback onVendre;
  final VoidCallback onReserver;
  final VoidCallback onDetails;
  final VoidCallback onSortie;
  final VoidCallback onRavitailler;
  const _LigneVariante({
    required this.variante,
    required this.admin,
    required this.onVendre,
    required this.onReserver,
    required this.onDetails,
    required this.onSortie,
    required this.onRavitailler,
  });

  @override
  Widget build(BuildContext context) {
    final qty = variante.quantite ?? 0;
    final taille =
        (variante.taille == null || variante.taille!.isEmpty)
            ? 'Unique'
            : variante.taille!;
    final bas = qty > 0 && qty <= BoutiquePageVctl.seuilStockBas;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                child: Text(
                  taille,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  variante.prix?.toAmount(unit: 'F') ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              Text(
                qty > 0 ? '$qty en stock' : 'Rupture',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      (qty <= 0 || bas) ? AppColors.secondary : AppColors.green,
                ),
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Expanded(child: _BoutonReserver(onTap: onReserver)),
              const Gap(10),
              Expanded(child: _BoutonVente(enabled: qty > 0, onTap: onVendre)),
            ],
          ),
          const Gap(4),
          Row(
            children: [
              _LienAction(
                icon: Icons.receipt_long_outlined,
                label: 'Détails',
                onTap: onDetails,
              ),
              if (admin) ...[
                _LienAction(
                  icon: Icons.add_rounded,
                  label: 'Ravitailler',
                  onTap: onRavitailler,
                ),
                _LienAction(
                  icon: Icons.remove_rounded,
                  label: 'Sortie',
                  couleur: Colors.red.shade700,
                  onTap: onSortie,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Action secondaire : un lien discret, pour ne pas concurrencer les deux
/// boutons principaux.
class _LienAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? couleur;
  final VoidCallback onTap;
  const _LienAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    final c = couleur ?? AppColors.primary;
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: c),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: c,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Bouton de réservation : second choix après la vente, donc contouré.
class _BoutonReserver extends StatelessWidget {
  final VoidCallback onTap;
  const _BoutonReserver({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.bookmark_add_outlined, size: 18),
      label: const Text('Réserver'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(0, 46),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Petit œil pour voir la photo en grand (zoom au pincement). Il intercepte le
/// toucher : cliquer dessus n'ouvre pas la feuille de la carte.
class _BoutonOeil extends StatelessWidget {
  final String url;
  final bool sombre;
  const _BoutonOeil({required this.url, this.sombre = false});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Voir l'image",
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.to(() => PreviewImagePage(url)),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color:
                sombre
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.92),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.visibility_outlined,
            size: 18,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Bouton de vente, plein et dans la couleur de marque : c'est l'action
/// principale de l'écran, elle ne doit pas se confondre avec un simple lien.
class _BoutonVente extends StatelessWidget {
  final bool enabled;
  final bool large;
  final VoidCallback onTap;
  const _BoutonVente({
    required this.enabled,
    required this.onTap,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(large ? 16 : 12);
    return Material(
      color: enabled ? AppColors.primary : Colors.grey.shade400,
      borderRadius: radius,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: radius,
        child: Padding(
          padding:
              large
                  ? const EdgeInsets.symmetric(vertical: 15)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: large ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: large ? 20 : 17,
                color: Colors.white,
              ),
              Gap(large ? 8 : 6),
              Text(
                large ? 'Faire une vente' : 'Vendre',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: large ? 15 : 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
