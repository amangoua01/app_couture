import 'package:ateliya/api/notification_api.dart';
import 'package:ateliya/data/models/notification.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/models/paginated_data.dart';
import 'package:ateliya/tools/widgets/messages/c_alert_dialog.dart';
import 'package:ateliya/views/controllers/abstract/paginable_view_controller.dart';

class NotifListVctl extends PaginableViewController<Notification> {
  final NotificationApi api = NotificationApi();

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  Future<void> getList({int page = 1, String? search}) async {
    startLoad(page);

    final res = await api.getNotifications(page: page).load();

    endLoad(page);

    if (res.status) {
      if (page == 1) {
        data = PaginatedData(items: res.data ?? [], page: page);
        data.hasMore = (res.data?.length ?? 0) >= 10;
      } else {
        if (res.data != null && res.data!.isNotEmpty) {
          data.append(PaginatedData(items: res.data!, page: page));
          data.hasMore = res.data!.length >= 10;
        } else {
          data.hasMore = false;
        }
      }
      update();
    } else {
      CAlertDialog.show(message: res.message);
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final res = await api.markAsRead(notificationId);
    if (res.status) {
      // Mettre à jour l'état de la notification localement
      final index = data.items.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        data.items[index].etat = true;
        update();
      }
    }
  }

  Future<bool> deleteNotification(int notificationId) async {
    final res = await api.delete(notificationId).load();
    if (res.status) {
      data.items.removeWhere((n) => n.id == notificationId);
      update();
      return true;
    } else {
      CAlertDialog.show(message: res.message);
      return false;
    }
  }
}
