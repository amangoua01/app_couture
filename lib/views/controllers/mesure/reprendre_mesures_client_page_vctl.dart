import 'package:ateliya/api/client_api.dart';
import 'package:ateliya/api/facture_api.dart';
import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:ateliya/data/dto/mesure/type_mesure_dto.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/ligne_mesure.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';

class ReprendreMesuresClientPageVctl extends AuthViewController {
  final clientApi = ClientApi();
  final factureApi = FactureApi();

  List<Client> allClients = [];
  List<Client> filteredClients = [];
  String searchText = "";

  Client? selectedClient;
  bool isLoadingHistory = false;
  List<PieceHistorique> pieces = [];

  @override
  void onInit() {
    super.onInit();
    _loadClients();
  }

  Future<void> _loadClients() async {
    final cached = await clientApi.readCachedList();
    if (cached != null && cached.isNotEmpty) {
      allClients = cached.items;
      update();
    }
    final res = await clientApi.list(useCache: true);
    if (res.status) {
      allClients = res.data!.items;
      update();
    }
  }

  void onSearchChanged(String text) {
    searchText = text;
    if (text.trim().isEmpty) {
      filteredClients = [];
    } else {
      final needle = text.toLowerCase().trim();
      filteredClients =
          allClients
              .where(
                (c) =>
                    c.fullName.toLowerCase().contains(needle) ||
                    (c.tel ?? '').toLowerCase().contains(needle),
              )
              .take(20)
              .toList();
    }
    update();
  }

  String? loadError;

  Future<void> selectClient(Client client) async {
    selectedClient = client;
    searchText = "";
    filteredClients = [];
    pieces = [];
    loadError = null;
    isLoadingHistory = true;
    update();

    final res = await factureApi.getFacturesByClient(client.id.value);
    isLoadingHistory = false;
    if (res.status) {
      pieces =
          res.data!
              .expand(
                (facture) => facture.lignesMesures.map(
                  (piece) =>
                      PieceHistorique(piece: piece, date: facture.dateDepot),
                ),
              )
              .toList();
    } else {
      // Distingue "le client n'a vraiment aucune commande" d'un échec
      // réseau/serveur : sans ça, les deux cas affichaient le même état
      // vide et masquaient un vrai problème (endpoint indisponible, etc.).
      loadError = res.message;
    }
    update();
  }

  void clearSelection() {
    selectedClient = null;
    pieces = [];
    update();
  }

  /// Construit un [LigneMesureDto] réutilisable tel quel par
  /// EditionPieceCouturePageVctl, exactement comme le fait déjà le flux de
  /// dictée vocale d'une pièce entière.
  LigneMesureDto buildDtoFrom(LigneMesure piece) {
    return LigneMesureDto(
      typeMesureDto: TypeMesureDto(
        id: piece.typeMesure?.id.value ?? 0,
        libelle: piece.typeMesure?.libelle.value ?? '',
        mensurations:
            piece.mensurations
                .map(
                  (m) => MensurationDto(
                    categorieMesure: m.categorieMesure ?? CategorieMesure(),
                    valeur: m.taille,
                  ),
                )
                .toList(),
      ),
      tailleStandard: piece.tailleStandard,
    );
  }
}

class PieceHistorique {
  final LigneMesure piece;
  final DateTime? date;

  PieceHistorique({required this.piece, required this.date});
}
