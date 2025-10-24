import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/extensions/types/int.dart';
import 'package:app_couture/tools/models/paginated_data.dart';
import 'package:app_couture/tools/widgets/messages/c_alert_dialog.dart';
import 'package:app_couture/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:app_couture/views/controllers/abstract/paginable_view_controller.dart';

abstract class ListViewController<M extends Model>
    extends PaginableViewController<M> {
  final CrudWebController api;

  bool isSearching = false;
  String? search;

  List<int>? selected;
  bool provideIdToListApi;

  ListViewController(
    this.api, {
    this.provideIdToListApi = true,
  });

  @override
  Future<void> getList({int page = 1, String? search}) async {
    startLoad(page);
    final res = await api.list(
      id: provideIdToListApi ? entite.id : null,
      page: page,
      search: search,
    );
    endLoad(page);
    if (res.status) {
      data = (res.data! as PaginatedData<M>);
      update();
    } else {
      CAlertDialog.show(message: res.message);
    }
  }

  void onSelect(int id) {
    selected ??= [];
    if (selected!.contains(id)) {
      selected!.remove(id);
    } else {
      selected!.add(id);
    }
    update();
  }

  void onSelectAll() {
    selected ??= [];
    if (selected!.length == data.length) {
      selected = [];
    } else {
      selected = List.generate(data.length, (i) => data.items[i].id.value);
    }
    update();
  }

  bool isSelected(int index) =>
      selected?.contains(data.items[index].id.value) == true;

  Future<void> onDeleteAllSelected() async {
    if (selected != null) {
      if (selected!.isNotEmpty) {
        var rep = await CChoiceMessageDialog.show(
          message:
              "Confirmez-vous la suppression de ${selected!.length} élément(s)",
          height: 100,
        );
        if (rep == true) {
          final res = await api.deleteMultiple(selected!);
          if (res.status) {
            await getList();
            if (data.isEmpty) {
              selected = null;
            } else {
              selected = [];
            }
            update();
          } else {
            CAlertDialog.show(message: res.message);
          }
        }
      } else {
        CAlertDialog.show(message: "Aucun élément sélectionné");
      }
    }
  }
}
