import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class MeilleureVente extends Model<MeilleureVente> {
  String? modeleNom;
  int quantiteTotale = 0;
  double chiffreAffaires = 0;
  Client? client;

  MeilleureVente({
    super.id,
    this.modeleNom,
    this.quantiteTotale = 0,
    this.chiffreAffaires = 0,
    this.client,
  });

  MeilleureVente.fromJson(Json json) {
    id = json['modele_id'];
    modeleNom = json['modele_nom'];
    quantiteTotale = json['quantite_totale'] ?? 0;
    chiffreAffaires = json['chiffre_affaires'].toString().toDouble().value;

    // Parse client (peut être null)
    if (json['client'] != null) {
      client = Client.fromJson(json['client']);
    }
  }

  @override
  MeilleureVente fromJson(Json json) => MeilleureVente.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      "modele_id": id,
      "modele_nom": modeleNom,
      "quantite_totale": quantiteTotale,
      "chiffre_affaires": chiffreAffaires,
      "client": client?.toJson(),
    };
  }
}
