import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class Reservation extends ModelJson {
  String? montant;
  String? dateRetrait;
  String? avance;
  String? reste;
  Client? client;
  String? createdAt;
  bool? isActive;

  Reservation({
    this.montant,
    this.dateRetrait,
    this.avance,
    this.reste,
    this.client,
    this.createdAt,
    this.isActive,
  });

  @override
  Reservation fromJson(Json json) {
    return Reservation.fromJson(json);
  }

  Reservation.fromJson(Json json) {
    id = json['id'];
    montant = json['montant'];
    dateRetrait = json['dateRetrait'];
    avance = json['avance'];
    reste = json['reste'];
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['montant'] = montant;
    data['dateRetrait'] = dateRetrait;
    data['avance'] = avance;
    data['reste'] = reste;
    data['client'] = client?.id;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }

  double get evolution {
    if (montant == null || avance == null) {
      return 0.0;
    }
    final double montantValue = montant.toDouble().value;
    final double avanceValue = avance.toDouble().value;
    if (montantValue == 0.0) {
      return 0.0;
    }
    return (avanceValue / montantValue);
  }
}
