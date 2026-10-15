import 'dart:convert';

import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/reservation.dart';
import 'package:ateliya/tools/components/data_cache.dart';
import 'package:ateliya/tools/models/data_response.dart';

/// Données d'une nouvelle réservation, telles que les attend le serveur.
class ReservationDto {
  final int clientId;
  final int boutiqueId;
  final int modeleBoutiqueId;
  final int quantite;
  final int montant;
  final int avance;
  final DateTime dateRetrait;
  final String moyenPaiement;

  ReservationDto({
    required this.clientId,
    required this.boutiqueId,
    required this.modeleBoutiqueId,
    required this.quantite,
    required this.montant,
    required this.avance,
    required this.dateRetrait,
    required this.moyenPaiement,
  });

  Map<String, dynamic> toJson() => {
    'client': clientId,
    'boutique': boutiqueId,
    'montant': montant,
    'avance': avance,
    'reste': montant - avance,
    'dateRetrait': dateRetrait.toIso8601String(),
    'moyenPaiement': moyenPaiement,
    'ligne': [
      {
        'modele': modeleBoutiqueId,
        'quantite': quantite,
        'avanceModele': avance,
      },
    ],
  };
}

class ReservationApi extends CrudWebController<Reservation> {
  @override
  Reservation get item => Reservation();

  @override
  String get module => "reservation";

  String _cacheKeyBoutique(int boutiqueId) => 'reservations:$boutiqueId';

  /// Dernière liste connue de la boutique, pour un affichage immédiat.
  Future<List<Reservation>?> readCachedByBoutique(int boutiqueId) async {
    final raw = await DataCache.readList(_cacheKeyBoutique(boutiqueId));
    if (raw == null) return null;
    try {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(Reservation.fromJson)
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<DataResponse<List<Reservation>>> listByBoutique(int boutiqueId) async {
    try {
      final res = await client.get(
        urlBuilder(api: "entreprise/by/boutique/$boutiqueId"),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final brut = data['data'];
        final liste = brut is List ? brut : const [];
        await DataCache.write(_cacheKeyBoutique(boutiqueId), liste);
        return DataResponse.success(
          data:
              liste
                  .whereType<Map<String, dynamic>>()
                  .map(Reservation.fromJson)
                  .toList(),
        );
      }
      return DataResponse.error(
        message:
            data['message'] ?? 'Erreur lors du chargement des réservations',
      );
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<Reservation>> detail(int id) async {
    try {
      final res = await client.get(
        urlBuilder(api: "get/one/$id"),
        headers: authHeaders,
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['data'] is Map<String, dynamic>) {
        return DataResponse.success(data: Reservation.fromJson(data['data']));
      }
      return DataResponse.error(
        message: data['message'] ?? 'Réservation introuvable',
      );
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<Reservation>> creer(ReservationDto dto) async {
    try {
      final res = await client.post(
        urlBuilder(api: "create"),
        headers: authHeaders,
        body: jsonEncode(dto.toJson()),
      );
      final data = jsonDecode(res.body);
      if ((res.statusCode == 200 || res.statusCode == 201) &&
          data['data'] is Map<String, dynamic>) {
        return DataResponse.success(data: Reservation.fromJson(data['data']));
      }
      return DataResponse.error(
        message: data['message'] ?? 'Erreur lors de la réservation',
      );
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  /// Encaisse un versement : le reste à payer diminue d'autant.
  Future<DataResponse<bool>> verser(
    int id, {
    required int montant,
    required String moyenPaiement,
  }) => _action("paiement/$id", {
    'montant': montant,
    'moyenPaiement': moyenPaiement,
  }, 'Erreur lors du versement');

  /// Confirme la réservation : le stock est déduit côté serveur. Si le stock
  /// manque, le serveur refuse et détaille les articles concernés.
  Future<DataResponse<bool>> confirmer(int id, {String? notes}) => _action(
    "confirm/$id",
    {if (notes != null && notes.isNotEmpty) 'notes': notes},
    'Erreur lors de la confirmation',
    detailStock: true,
  );

  Future<DataResponse<bool>> annuler(int id, {String? motif}) => _action(
    "cancel/$id",
    {if (motif != null && motif.isNotEmpty) 'reason': motif},
    "Erreur lors de l'annulation",
  );

  Future<DataResponse<bool>> _action(
    String api,
    Map<String, dynamic> corps,
    String erreurParDefaut, {
    bool detailStock = false,
  }) async {
    try {
      final res = await client.post(
        urlBuilder(api: api),
        headers: authHeaders,
        body: jsonEncode(corps),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        await invalidateCache();
        // Les listes en cache ne reflètent plus la réalité : on les retire pour
        // que la prochaine ouverture ne montre pas l'état d'avant l'action.
        await DataCache.invalidate('reservations:');
        return DataResponse.success(data: true);
      }
      var message = (data['message'] ?? erreurParDefaut).toString();
      if (detailStock) {
        final manquants = data['data']?['insufficient_items'];
        if (manquants is List && manquants.isNotEmpty) {
          final lignes = manquants.whereType<Map>().map((m) {
            final dispo = m['available_boutique'] ?? m['available_global'] ?? 0;
            return '• ${m['modele_name']} : ${m['requested']} demandé(s), $dispo disponible(s)';
          });
          message = '$message\n${lignes.join('\n')}';
        }
      }
      return DataResponse.error(message: message);
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
