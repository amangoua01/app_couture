import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class EntreStock extends ModelJson {
  String? date;
  int? quantite;
  String? statut;
  String? commentaire;
  String? createdAt;
  bool? isActive;
  String? type;
  User? creator;

  EntreStock({
    this.date,
    this.quantite,
    this.statut,
    this.commentaire,
    this.createdAt,
    this.isActive,
    this.type,
    this.creator,
  });

  @override
  EntreStock fromJson(Json json) {
    return EntreStock.fromJson(json);
  }

  EntreStock.fromJson(Json json) {
    id = json['id'];
    date = json['date'];
    quantite = json['quantite'];
    statut = json['statut'];
    commentaire = json['commentaire'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    type = json['type'];
    creator =
        json['createdBy'] != null ? User.fromJson(json['createdBy']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['quantite'] = quantite;
    data['statut'] = statut;
    data['commentaire'] = commentaire;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    data['type'] = type;
    data['createdBy'] = creator?.toJson();
    return data;
  }

  bool get isEntree => type == 'Entree';
  bool get isSortie => type == 'Sortie';
}
