import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class Settings extends ModelJson {
  int nombreUser = 0;
  int nombreSms = 0;
  int nombreSuccursale = 0;
  int nombreJourRestantPourEnvoyerSms = 0;
  int numeroAbonnement = 0;
  String? messageFactureBoutique;
  String? messageFactureAtelier;
  DateTime? createdAt;
  bool isActive = false;

  Settings({
    super.id,
    this.nombreUser = 0,
    this.nombreSms = 0,
    this.nombreSuccursale = 0,
    this.nombreJourRestantPourEnvoyerSms = 0,
    this.numeroAbonnement = 0,
    this.messageFactureBoutique,
    this.messageFactureAtelier,
    this.createdAt,
    this.isActive = false,
  });

  Settings.fromJson(Json json) {
    id = json["id"];
    nombreUser = json["nombreUser"] ?? 0;
    nombreSms = json["nombreSms"] ?? 0;
    nombreSuccursale = json["nombreSuccursale"] ?? 0;
    nombreJourRestantPourEnvoyerSms =
        json["nombreJourRestantPourEnvoyerSms"] ?? 0;
    numeroAbonnement = json["numeroAbonnement"] ?? 0;
    messageFactureBoutique = json["messageFactureBoutique"];
    messageFactureAtelier = json["messageFactureAtelier"];
    createdAt = json["createdAt"].toString().toDateTime();
    isActive = json["isActive"] ?? false;
  }

  @override
  Settings fromJson(Json json) => Settings.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombreUser": nombreUser,
        "nombreSms": nombreSms,
        "nombreSuccursale": nombreSuccursale,
        "nombreJourRestantPourEnvoyerSms": nombreJourRestantPourEnvoyerSms,
        "numeroAbonnement": numeroAbonnement,
        "messageFactureBoutique": messageFactureBoutique,
        "messageFactureAtelier": messageFactureAtelier,
        "createdAt": createdAt?.toIso8601String(),
        "isActive": isActive,
      };
}
