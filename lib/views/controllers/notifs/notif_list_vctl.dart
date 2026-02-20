import 'package:ateliya/api/notification_api.dart';
import 'package:ateliya/data/models/notification.dart';
import 'package:ateliya/tools/extensions/future.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/models/paginated_data.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/paginable_view_controller.dart';

class NotifListVctl extends PaginableViewController<Notification> {
  final NotificationApi api = NotificationApi();

  /// IDs sélectionnés pour suppression multiple
  final Set<int> selectedIds = {};

  bool get isSelectionMode => selectedIds.isNotEmpty;

  // ── Sélection ──────────────────────────────────────────────────────────────

  void toggleSelect(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    update();
  }

  void selectAll() {
    for (final n in data.items) {
      if (n.id != null) selectedIds.add(n.id!);
    }
    update();
  }

  void clearSelection() {
    selectedIds.clear();
    update();
  }

  bool isSelected(int id) => selectedIds.contains(id);

  // ── Chargement ─────────────────────────────────────────────────────────────

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
      CMessageDialog.show(message: res.message);
    }
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> markAsRead(Notification notification) async {
    final res = await api.markAsRead(notification.id.value);
    if (res.status) {
      notification.isRead = false;
      update();
    }
  }

  Future<bool> deleteNotification(int notificationId) async {
    final res = await api.delete(notificationId).load();
    if (res.status) {
      data.items.removeWhere((n) => n.id == notificationId);
      selectedIds.remove(notificationId);
      update();
      return true;
    } else {
      CMessageDialog.show(message: res.message);
      return false;
    }
  }

  /// Supprime toutes les notifications sélectionnées via un seul appel API.
  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) return;

    final idsToDelete = List<int>.from(selectedIds);

    final res = await api.deleteMultiple(idsToDelete).load();

    if (res.status) {
      data.items.removeWhere((n) => n.id != null && idsToDelete.contains(n.id));
      selectedIds.clear();
      update();
    } else {
      CMessageDialog.show(message: res.message);
    }
  }
}
