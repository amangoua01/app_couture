import 'package:ateliya/api/modele_boutique_api.dart';
import 'package:ateliya/data/models/modele_boutique.dart';
import 'package:ateliya/data/models/modele_boutique_details.dart';
import 'package:ateliya/tools/models/detail_model_filter_vente.dart';
import 'package:ateliya/tools/models/detail_modele_entre_stock.dart';
import 'package:ateliya/tools/models/detail_modele_reservation_filter.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:get/get.dart';

class DetailBoutiqueItemPageVctl extends GetxController {
  final ModeleBoutique modele;
  final filterVente = DetailModelFilterVente();
  final filterReservation = DetailModeleReservationFilter();
  final entreStockFilter = DetailModeleEntreStock();
  final api = ModeleBoutiqueApi();

  ModeleBoutiqueDetails? details;
  bool isLoading = false;

  DetailBoutiqueItemPageVctl(this.modele);

  /// Derniers détails vus, par article : rouvrir une fiche déjà consultée
  /// l'affiche aussitôt, le temps que la version à jour arrive.
  static final Map<int, ModeleBoutiqueDetails> _cache = {};

  Future<void> loadDetails() async {
    if (modele.id == null) return;

    // Mémoire de la session, sinon dernière version enregistrée sur
    // l'appareil : la fiche s'affiche aussitôt même après un redémarrage.
    final enCache =
        _cache[modele.id!] ?? await api.readCachedDetails(modele.id!);
    if (enCache != null) {
      details = enCache;
    } else {
      // Pas de masque plein écran : la page et ses onglets s'affichent tout de
      // suite, seule la zone de contenu indique le chargement.
      isLoading = true;
    }
    update();

    final res = await api.getDetails(modele.id!);

    isLoading = false;
    if (res.status) {
      details = res.data;
      _cache[modele.id!] = res.data!;
    } else if (details == null) {
      CMessageDialog.show(message: res.message);
    }
    update();
  }

  // Filtrage des ventes
  List<VenteItem> get filteredVentes {
    if (details == null) return [];

    var ventes = details!.ventes;

    // Filtre par client
    if (filterVente.client != null) {
      ventes =
          ventes.where((v) {
            return v.paiementBoutique?.client?.id == filterVente.client!.id;
          }).toList();
    }

    // Filtre par date de début
    if (filterVente.dateDebut.dateTime != null) {
      ventes =
          ventes.where((v) {
            final date = v.paiementBoutique?.createdAt;
            return date != null &&
                date.isAfter(filterVente.dateDebut.dateTime!);
          }).toList();
    }

    // Filtre par date de fin
    if (filterVente.dateFin.dateTime != null) {
      ventes =
          ventes.where((v) {
            final date = v.paiementBoutique?.createdAt;
            return date != null && date.isBefore(filterVente.dateFin.dateTime!);
          }).toList();
    }

    return ventes;
  }

  // Filtrage des réservations
  List<ReservationItem> get filteredReservations {
    if (details == null) return [];

    var reservations = details!.reservations;

    // Filtre par client
    if (filterReservation.client != null) {
      reservations =
          reservations.where((r) {
            return r.reservation?.client?.id == filterReservation.client!.id;
          }).toList();
    }

    // Filtre par statut
    if (filterReservation.status != null) {
      reservations =
          reservations.where((r) {
            return r.reservation?.status == filterReservation.status;
          }).toList();
    }

    // Filtre par date de début
    if (filterReservation.dateDebut.dateTime != null) {
      reservations =
          reservations.where((r) {
            final date = r.reservation?.createdAt;
            return date != null &&
                date.isAfter(filterReservation.dateDebut.dateTime!);
          }).toList();
    }

    // Filtre par date de fin
    if (filterReservation.dateFin.dateTime != null) {
      reservations =
          reservations.where((r) {
            final date = r.reservation?.createdAt;
            return date != null &&
                date.isBefore(filterReservation.dateFin.dateTime!);
          }).toList();
    }

    return reservations;
  }

  // Filtrage des mouvements
  List<MouvementStock> get filteredMouvements {
    if (details == null) return [];

    var mouvements = details!.mouvements;

    // Filtre par date de début
    if (entreStockFilter.dateDebut.dateTime != null) {
      mouvements =
          mouvements.where((m) {
            final date = m.entreStock?.date;
            return date != null &&
                date.isAfter(entreStockFilter.dateDebut.dateTime!);
          }).toList();
    }

    // Filtre par date de fin
    if (entreStockFilter.dateFin.dateTime != null) {
      mouvements =
          mouvements.where((m) {
            final date = m.entreStock?.date;
            return date != null &&
                date.isBefore(entreStockFilter.dateFin.dateTime!);
          }).toList();
    }

    return mouvements;
  }

  // Récupérer la liste des clients depuis les ventes
  List<String> get clientsFromVentes {
    if (details == null) return [];

    final clients =
        details!.ventes
            .where((v) => v.paiementBoutique?.client != null)
            .map((v) => v.paiementBoutique!.client!.fullName)
            .toSet()
            .toList();

    return clients;
  }

  // Récupérer la liste des clients depuis les réservations
  List<String> get clientsFromReservations {
    if (details == null) return [];

    final clients =
        details!.reservations
            .where((r) => r.reservation?.client != null)
            .map((r) => r.reservation!.client!.fullName)
            .toSet()
            .toList();

    return clients;
  }

  @override
  void onInit() {
    loadDetails();
    super.onInit();
  }
}
