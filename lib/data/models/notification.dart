import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/extensions/types/string.dart';

class Notification extends Model<Notification> {
  bool? etat;
  String? titre;
  String? libelle;
  String? createdAt;
  bool? isActive;

  Notification({
    super.id,
    this.etat,
    this.titre,
    this.libelle,
    this.createdAt,
    this.isActive,
  });

  Notification.fromJson(Json json) {
    id = json['id'];
    etat = json['etat'];
    titre = json['titre'];
    libelle = json['libelle'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
  }

  @override
  Notification fromJson(Json json) => Notification.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'etat': etat,
      'titre': titre,
      'libelle': libelle,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }

  /// Retourne la date formatée
  String get dateFormatted {
    if (createdAt == null) return '-';
    final date = createdAt!.toDateTime();
    if (date == null) return createdAt!;

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'À l\'instant';
        }
        return 'Il y a ${difference.inMinutes} min';
      }
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return date.toFrenchDateTime;
    }
  }
}
