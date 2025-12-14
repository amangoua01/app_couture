import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/wrapper_listview_from_view_controller.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Enums et extensions manquants
enum PermissionKey { lecture, creation, suppression }

extension UserPermissions on User {
  bool hasPermission(dynamic ftKey, PermissionKey permission) {
    // Implémentation basique - à adapter selon votre logique métier
    return true;
  }
}

extension ListViewControllerExtensions on ListViewController {
  dynamic get ftKey => null; // À adapter selon votre logique
}

class User {
  // Classe User basique - à adapter selon votre modèle
}

class BodyListView<T> extends StatelessWidget {
  final String title;
  final ListViewController ctl;
  final ListItem? Function(BuildContext, int, bool isSelected) itemBuilder;
  final Widget? createPage;
  final bool withCreateButton;
  final Key? actionKey;
  final List<Widget> actions;
  final Widget? bottomNavigationBar;
  final bool enableMultipleDeletion;
  final bool enableSearch;

  const BodyListView(
    this.ctl, {
    this.bottomNavigationBar,
    this.actions = const [],
    this.actionKey,
    this.withCreateButton = true,
    required this.itemBuilder,
    this.createPage,
    required this.title,
    this.enableMultipleDeletion = true,
    this.enableSearch = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: ctl.selected == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ctl.selected = null;
          ctl.update();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: ternaryFn(
              condition: ctl.isSearching,
              ifTrue: const Size.fromHeight(100),
              ifFalse: const Size.fromHeight(0),
            ),
            child: Visibility(
              visible: ctl.isSearching,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CTextFormField(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Rechercher",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  onChanged: (e) {
                    ctl.search = e;
                    ctl.update();
                    ctl.getList(search: e);
                  },
                ),
              ),
            ),
          ),
          actions: [
            ...actions,
            Visibility(
              visible: enableSearch,
              child: IconButton(
                onPressed: () {
                  ctl.isSearching = !ctl.isSearching;
                  if (!ctl.isSearching) {
                    ctl.search = null;
                    ctl.getList();
                  }
                  ctl.update();
                },
                icon: Icon(
                  ternaryFn(
                    condition: ctl.isSearching,
                    ifTrue: Icons.search_off,
                    ifFalse: Icons.search,
                  ),
                  color: AppColors.primary,
                ),
              ),
            ),
            PlaceholderBuilder(
              condition: ctl.selected == null,
              placeholder: IconButton(
                splashRadius: 20,
                tooltip: "Annuler la sélection",
                icon: const Icon(Icons.close),
                onPressed: () {
                  ctl.selected = null;
                  ctl.update();
                },
              ),
              builder: () {
                return PopupMenuButton(
                  key: actionKey,
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Actualiser"),
                    ),
                  ]..addIf(
                      enableMultipleDeletion,
                      const PopupMenuItem(
                        value: 2,
                        child: Text("Suppression multiple"),
                      ),
                    ),
                  onSelected: (e) {
                    if (e == 1) {
                      ctl.getList(search: ctl.search);
                    } else {
                      ctl.selected = [];
                      ctl.update();
                    }
                  },
                );
              },
            ),
            Visibility(
              visible: ctl.selected != null,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Checkbox(
                  value: ctl.data.length == ctl.selected?.length,
                  onChanged: (e) => ctl.onSelectAll(),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: bottomNavigationBar,
        body: WrapperListviewFromViewController(
          itemBuilder: (context, index) => itemBuilder(
            context,
            index,
            ctl.isSelected(index),
          ),
          ctl: ctl,
        ),
        floatingActionButton: Visibility(
          visible: withCreateButton,
          child: PlaceholderBuilder(
            condition: createPage != null || ctl.selected != null,
            builder: () {
              return FloatingActionButton(
                onPressed: () async {
                  if (ctl.selected == null) {
                    if (createPage != null) {
                      final res = await Get.to(
                        () => createPage!,
                        routeName: createPage.toString(),
                      );
                      if (res != null) {
                        ctl.data.items.insert(0, res);
                        ctl.update();
                      }
                    }
                  } else {
                    ctl.onDeleteAllSelected();
                  }
                },
                child: PlaceholderBuilder(
                  condition: ctl.selected == null,
                  placeholder: const Icon(Icons.delete),
                  builder: () => const Icon(Icons.add),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
