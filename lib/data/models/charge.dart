import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/constants/periodicite_charge.dart';

/// Charge récurrente propre à l'entreprise (ex: "Salaire Konaté", "Loyer
/// bureau") : un montant par défaut et une périodicité, pour pré-remplir
/// rapidement une nouvelle dépense.
class Charge extends Model<Charge> {
  String? libelle;
  String? montant;
  PeriodiciteCharge? periodicite;
  FamilleDepense? familleDepense;
  bool? isActive;

  Charge({
    super.id,
    this.libelle,
    this.montant,
    this.periodicite,
    this.familleDepense,
    this.isActive,
  });

  Charge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    montant = json['montant']?.toString();
    periodicite = PeriodiciteCharge.fromCode(json['periodicite']);
    familleDepense =
        json['familleDepense'] != null
            ? FamilleDepense.fromJson(json['familleDepense'])
            : null;
    isActive = json['isActive'];
  }

  @override
  Charge fromJson(Map<String, dynamic> json) => Charge.fromJson(json);

  Map<String, dynamic> toJson() => {
    "id": id,
    "libelle": libelle,
    "montant": montant,
    "periodicite": periodicite?.code,
    "familleDepenseId": familleDepense?.id,
  };
}
