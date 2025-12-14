import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/reservation.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class LigneReservations extends ModelJson {
  int? quantite;
  Reservation? reservation;
  String? avanceModele;
  String? createdAt;
  bool? isActive;

  LigneReservations({
    this.quantite,
    this.reservation,
    this.avanceModele,
    this.createdAt,
    this.isActive,
  });

  @override
  LigneReservations fromJson(Json json) {
    return LigneReservations.fromJson(json);
  }

  LigneReservations.fromJson(Json json) {
    quantite = json['quantite'];
    reservation = json['reservation'] != null
        ? Reservation.fromJson(json['reservation'])
        : null;
    avanceModele = json['avanceModele'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantite'] = quantite;
    if (reservation != null) {
      data['reservation'] = reservation!.toJson();
    }
    data['avanceModele'] = avanceModele;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}