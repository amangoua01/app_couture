import 'package:ateliya/api/personnel_api.dart';
import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class PersonnelsListPageVctl extends ListViewController<User> {
  PersonnelsListPageVctl() : super(PersonnelApi());

  final personnelApi = PersonnelApi();
  final togglingIds = <int>{};

  Future<void> toggleActive(User user) async {
    final id = user.id;
    if (id == null || togglingIds.contains(id)) return;

    togglingIds.add(id);
    update();

    final res = await personnelApi.toggleActive(id);
    togglingIds.remove(id);

    if (res.status) {
      user.isActive = !(user.isActive ?? true);
    } else {
      CMessageDialog.show(message: res.message);
    }
    update();
  }
}
