import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/constants/env.dart';
import 'package:app_couture/tools/extensions/types/int.dart';

class PaginatedData<M extends Model> {
  List<M> items;
  int page;
  bool hasMore = false;

  PaginatedData({
    this.items = const [],
    this.page = 1,
  }) {
    if (items.isEmpty) {
      hasMore = false;
    } else {
      if (items.length < Env.nbItemInListPage) {
        hasMore = false;
      } else {
        hasMore = true;
      }
    }
  }

  int get length => items.length;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  void clear() {
    items.clear();
    page = 1;
    hasMore = false;
  }

  void append(PaginatedData<M> other) {
    if (other.isNotEmpty) {
      if (items.isEmpty) {
        items = other.items;
      } else {
        final ids = items.map((e) => e.id.value);
        final newList =
            other.items.where((item) => !ids.contains(item.id.value));
        if (newList.isNotEmpty) {
          items.addAll(newList);
        }
      }

      if (other.length < Env.nbItemInListPage) {
        hasMore = false;
      } else {
        hasMore = true;
      }
    } else {
      hasMore = false;
    }
    page = other.page;
  }

  void removeWhere(bool Function(M element) test) {
    items.removeWhere(test);
  }

  Iterable<M> where(bool Function(M element) test) => items.where(test);

  M firstWhere(bool Function(M element) test) => items.firstWhere(test);

  int get nextPage => page + 1;
}
