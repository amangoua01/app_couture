import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Kpis extends ModelJson {
  int? chiffreAffaires;
  int? reservationsActives;
  int? clientsActifs;
  int? commandesEnCours;

  Kpis({
    this.chiffreAffaires,
    this.reservationsActives,
    this.clientsActifs,
    this.commandesEnCours,
  });

  @override
  Kpis fromJson(Json json) {
    return Kpis.fromJson(json);
  }

  Kpis.fromJson(Json json) {
    chiffreAffaires = json['chiffreAffaires'];
    reservationsActives = json['reservationsActives'];
    clientsActifs = json['clientsActifs'];
    commandesEnCours = json['commandesEnCours'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chiffreAffaires'] = chiffreAffaires;
    data['reservationsActives'] = reservationsActives;
    data['clientsActifs'] = clientsActifs;
    data['commandesEnCours'] = commandesEnCours;
    return data;
  }
}