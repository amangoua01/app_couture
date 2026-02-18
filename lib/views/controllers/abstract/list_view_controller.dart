import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/models/paginated_data.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/paginable_view_controller.dart';

abstract class ListViewController<M extends Model>
    extends PaginableViewController<M> {
  final CrudWebController api;

  bool isSearching = false;
  String? search;

  List<int>? selected;
  bool provideIdToListApi;
  int? customId;

  ListViewController(
    this.api, {
    this.provideIdToListApi = false,
    this.customId,
  });

  @override
  Future<void> getList({int page = 1, String? search}) async {
    startLoad(page);
    int? finalId;
    if (customId != null) {
      finalId = customId;
    } else {
      finalId = getEntite().value.id;
    }
    final res = await api.list(
      id: provideIdToListApi ? finalId : null,
      page: page,
      search: search,
    );
    endLoad(page);
    if (res.status) {
      data = (res.data! as PaginatedData<M>);
      update();
    } else {
      CMessageDialog.show(message: res.message);
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
            CMessageDialog.show(message: res.message);
          }
        }
      } else {
        CMessageDialog.show(message: "Aucun élément sélectionné");
      }
    }
  }
}
