import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class PaiementBoutique extends ModelJson {
  int? quantite;
  Client? client;
  String? createdAt;
  bool? isActive;

  PaiementBoutique({this.quantite, this.client, this.createdAt, this.isActive});

  @override
  PaiementBoutique fromJson(Json json) {
    return PaiementBoutique.fromJson(json);
  }

  PaiementBoutique.fromJson(Json json) {
    quantite = json['quantite'];
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantite'] = quantite;
    data['client'] = client?.id;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    return data;
  }
}
