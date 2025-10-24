import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/models/paginated_data.dart';
import 'package:app_couture/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class PaginableViewController<M extends Model>
    extends AuthViewController {
  PaginatedData<M> _data = PaginatedData();
  final scrollCtl = ScrollController();
  bool isLoading = false;
  bool isMoreLoading = false;

  Future<void> getList({int page = 1});

  @override
  void onInit() {
    scrollCtl.addListener(() {
      if (scrollCtl.position.pixels == scrollCtl.position.maxScrollExtent) {
        if (_data.hasMore) {
          getList(page: _data.nextPage);
        } else {
          getList(page: _data.page);
          if (kDebugMode) print("No more data");
        }
      }
    });
    super.onInit();
  }

  PaginatedData<M> get data => _data;

  set data(PaginatedData<M> value) {
    if (value.page == 1) {
      _data = value;
    } else {
      _data.append(value);
    }
  }

  void startLoad(int page) {
    if (page == 1) {
      if (data.isEmpty) {
        isLoading = true;
      } else {
        isMoreLoading = true;
      }
    } else {
      isMoreLoading = true;
    }
    update();
  }

  void endLoad(int page) {
    if (page == 1) {
      if (data.isEmpty) {
        isLoading = false;
      } else {
        isMoreLoading = false;
      }
    } else {
      isMoreLoading = false;
    }
    update();
  }

  @override
  void onReady() {
    getList();
    super.onReady();
  }

  @override
  void onClose() {
    scrollCtl.dispose();
    super.onClose();
  }
}
