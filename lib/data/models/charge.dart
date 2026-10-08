import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/data/models/employe.dart';
import 'package:ateliya/data/models/famille_depense.dart';
import 'package:ateliya/tools/constants/periodicite_charge.dart';

/// Charge récurrente propre à l'entreprise (ex: "Salaire Konaté", "Loyer
/// bureau") : un montant par défaut et une périodicité, pour pré-remplir
/// rapidement une nouvelle dépense. Peut être liée à un ouvrier non
/// rémunéré à la pièce (salaire fixe) : voir BilanPersonnelUseCase côté
/// backend, qui additionne déjà ces charges dans le bilan de l'employé.
class Charge extends Model<Charge> {
  String? libelle;
  String? montant;
  PeriodiciteCharge? periodicite;
  FamilleDepense? familleDepense;
  Employe? employe;
  bool? isActive;

  Charge({
    super.id,
    this.libelle,
    this.montant,
    this.periodicite,
    this.familleDepense,
    this.employe,
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
    employe = json['employe'] != null ? Employe.fromJson(json['employe']) : null;
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
    "employeId": employe?.id,
  };
}
