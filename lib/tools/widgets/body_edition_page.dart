import 'package:ateliya/data/models/abstract/model.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/views/controllers/abstract/edition_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BodyEditionPage<M extends Model> extends StatelessWidget {
  final M? item;
  final EditionViewController ctl;
  final String module;
  final List<Widget> children;
  final List<Tab> tabs;
  final List<Widget> tabViewContent;
  final bool readOnly;
  final bool isTabScrollable;
  final bool hideBottomButton;
  final void Function(int)? onTabChange;

  const BodyEditionPage(
    this.ctl, {
    this.onTabChange,
    this.isTabScrollable = false,
    this.hideBottomButton = false,
    this.readOnly = false,
    this.tabViewContent = const [],
    required this.module,
    this.tabs = const [],
    this.item,
    this.children = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: PlaceholderWidget(
              condition: !readOnly,
              placeholder: Text("Détails $module"),
              child: Text("${item == null ? "Création" : "Edition"} $module"),
            ),
            bottom: (tabs.isNotEmpty)
                ? TabBar(
                    isScrollable: isTabScrollable,
                    tabs: tabs,
                    onTap: onTabChange,
                  )
                : null,
          ),
          body: Column(
            children: [
              Visibility(
                visible: readOnly,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.amber,
                    leading: const Icon(Icons.warning_amber_outlined),
                    title: const Text(
                      "Vous êtes en lecture seule",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PlaceholderBuilder(
                  condition: tabViewContent.isNotEmpty,
                  builder: () => TabBarView(
                    children: [
                      Form(
                        key: ctl.formKey,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(20),
                                physics: const BouncingScrollPhysics(),
                                children: children,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                bottom: 35,
                                top: 20,
                              ),
                              child: Visibility(
                                visible: !hideBottomButton,
                                child: CButton(
                                  title: "Valider",
                                  onPressed: ctl.submit,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...tabViewContent,
                    ],
                  ),
                  placeholder: Form(
                    key: ctl.formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ...children,
                        const Gap(20),
                        Visibility(
                          visible: !hideBottomButton,
                          child: Visibility(
                            visible: tabViewContent.isEmpty && !readOnly,
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CButton(
                                  title: "Valider",
                                  onPressed: ctl.submit,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
