import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class Kpis extends ModelJson {
  int chiffreAffaires = 0;
  int reservationsActives = 0;
  int clientsActifs = 0;
  int commandesEnCours = 0;

  Kpis({
    this.chiffreAffaires = 0,
    this.reservationsActives = 0,
    this.clientsActifs = 0,
    this.commandesEnCours = 0,
  });

  @override
  Kpis fromJson(Json json) {
    return Kpis.fromJson(json);
  }

  Kpis.fromJson(Json json) {
    chiffreAffaires = json['chiffreAffaires'] ?? 0;
    reservationsActives = json['reservationsActives'] ?? 0;
    clientsActifs = json['clientsActifs'] ?? 0;
    commandesEnCours = json['commandesEnCours'] ?? 0;
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
