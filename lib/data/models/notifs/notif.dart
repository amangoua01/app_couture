import 'dart:math';

import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/data/models/notifs/notif_data.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notif extends ModelJson<Notif> {
  String? title;
  String? body;
  int? userId;
  String? readAt;
  String? createdAt;
  String? updatedAt;
  NotifData? data;

  Notif({super.id, this.title, this.body, this.userId, this.readAt});

  Notif.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    userId = json['user_id'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json["data"] is Map) {
      data = NotifData.fromJson(json["data"]);
    }
  }

  Notif.fromRemonteMessage(RemoteMessage message) {
    if (message.notification != null) {
      title = message.notification!.title;
      body = message.notification!.body;
    } else {
      title = message.data["title"];
      body = message.data["body"];
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['message'] = body;
    data['user_id'] = userId;
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['data'] = data;
    return data;
  }

  @override
  Notif fromJson(Json json) {
    return Notif.fromJson(json);
  }

  int get idOrRandom => Random().nextInt(9999);

  String get initial => (title != null) ? title!.substring(0, 1) : "N";

  bool get isRead => readAt != null;
}
