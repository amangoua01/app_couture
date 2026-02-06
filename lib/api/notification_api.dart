import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/notification.dart';
import 'package:ateliya/tools/models/data_response.dart';

class NotificationApi extends WebController {
  @override
  String get module => "notification";

  Future<DataResponse<List<Notification>>> getNotifications({
    int page = 1,
    int itemsPerPage = 10,
  }) async {
    try {
      final res = await client.get(
        urlBuilder(
          api: "",
          params: {
            'page': page.toString(),
            'itemsPerPage': itemsPerPage.toString(),
          },
        ),
        headers: authHeaders,
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final List<Notification> notifications = [];
        if (data['data'] != null) {
          for (var item in data['data']) {
            notifications.add(Notification.fromJson(item));
          }
        }
        return DataResponse.success(data: notifications);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<bool>> markAsRead(int notificationId) async {
    try {
      final res = await client.post(
        urlBuilder(api: "$notificationId/read"),
        headers: authHeaders,
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return DataResponse.success(data: true);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<int>> getUnreadCount() async {
    try {
      final res = await client.get(
        urlBuilder(api: "count-unread"),
        headers: authHeaders,
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return DataResponse.success(data: data['data']["count"] ?? 0);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<bool>> delete(int notificationId) async {
    try {
      final res = await client.delete(
        urlBuilder(api: "$notificationId"),
        headers: authHeaders,
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return DataResponse.success(data: true);
      } else {
        return DataResponse.error(
            message: data['message'] ?? res.reasonPhrase ?? 'Erreur inconnue');
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
