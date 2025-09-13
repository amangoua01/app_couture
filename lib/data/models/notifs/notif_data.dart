import 'package:app_couture/data/models/notifs/notif_action.dart';

class NotifData {
  int unRead = 0;
  List<NotifAction> actions = [];

  NotifData({required this.unRead, required this.actions});

  NotifData.fromJson(Map<String, dynamic> json) {
    unRead = json['unread'] ?? 0;
    if (json['actions'] is List) {
      actions = <NotifAction>[];
      for (var v in (json['actions'] as List)) {
        actions.add(
          NotifAction(
            title: v['title'],
            type: v['type'],
            value: v['value'],
          ),
        );
      }
    }
  }
}
