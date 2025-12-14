import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ListItem<M extends ModelJson> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? leadingImage;
  final ListViewController ctl;
  final int index;
  final Widget editionPage;
  final void Function(M item)? onTap;
  final bool editable;
  final bool deletable;
  final bool selected;
  final bool displayBadge;
  final Widget? badgeWidget;
  final List<PopupMenuItem> actions;
  final void Function(M? item)? actionAfterEdit;
  final Color? backgroundColor;
  final double leadingImageSize;

  const ListItem(
    this.ctl, {
    this.leadingImageSize = 30.0,
    this.badgeWidget,
    this.selected = false,
    this.displayBadge = false,
    this.actionAfterEdit,
    this.deletable = true,
    this.editable = true,
    this.actions = const [],
    required this.editionPage,
    this.onTap,
    required this.index,
    required this.title,
    this.leadingImage,
    this.subtitle,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlaceholderBuilder(
      condition: ctl.selected == null,
      placeholder: CheckboxListTile(
        value: ctl.isSelected(index),
        enabled: deletable,
        secondary: PlaceholderBuilder(
          condition: leadingImage != null,
          builder: () => Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: PlaceholderWidget(
              condition: !leadingImage.value.endsWith(".json"),
              placeholder: Lottie.asset(leadingImage.value),
              child: PlaceholderWidget(
                condition: !leadingImage.value.startsWith("http"),
                placeholder: ClipOval(
                  child: Image.network(
                    leadingImage.value,
                    width: leadingImageSize,
                    height: leadingImageSize,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        "assets/images/svg/image_broken.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.cover,
                        width: leadingImageSize,
                        height: leadingImageSize,
                      );
                    },
                  ),
                ),
                child: PlaceholderWidget(
                  condition: !leadingImage.value.endsWith(".svg"),
                  placeholder: SvgPicture.asset(
                    leadingImage.value,
                    width: leadingImageSize,
                    height: leadingImageSize,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  child: Image.asset(
                    leadingImage.value,
                    width: leadingImageSize,
                    height: leadingImageSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        onChanged: (e) {
          if (deletable) ctl.onSelect(ctl.data.items[index].id.value);
        },
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
      ),
      builder: () {
        return ListTile(
          selected: selected,
          selectedColor: AppColors.primary,
          selectedTileColor: AppColors.primary.withAlpha(50),
          leading: PlaceholderBuilder(
            condition: leadingImage != null,
            builder: () => Badge(
              label: badgeWidget,
              backgroundColor: backgroundColor,
              isLabelVisible: displayBadge,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: PlaceholderWidget(
                  condition: !leadingImage.value.endsWith(".json"),
                  placeholder: Lottie.asset(leadingImage.value),
                  child: PlaceholderWidget(
                    condition: !leadingImage.value.endsWith(".svg"),
                    placeholder: SvgPicture.asset(
                      leadingImage.value,
                      width: leadingImageSize,
                      height: leadingImageSize,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    child: PlaceholderWidget(
                      condition: !leadingImage.value.startsWith("http"),
                      placeholder: ClipOval(
                        child: Image.network(
                          leadingImage.value,
                          width: leadingImageSize,
                          height: leadingImageSize,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return SvgPicture.asset(
                              "assets/images/svg/image_broken.svg",
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                              fit: BoxFit.cover,
                              width: leadingImageSize,
                              height: leadingImageSize,
                            );
                          },
                        ),
                      ),
                      child: Image.asset(
                        leadingImage.value,
                        width: leadingImageSize,
                        height: leadingImageSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          onLongPress: () {
            if (deletable) ctl.onSelect(ctl.data.items[index].id.value);
          },
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          onTap: () async {
            var item = ctl.data.items[index];
            if (onTap == null) {
              if (editable) {
                final res = await Get.to(
                  () => editionPage,
                  routeName: editionPage.toString(),
                );
                if (res != null) {
                  item = res;
                  ctl.update();
                }
                if (actionAfterEdit != null) actionAfterEdit!(res);
              }
            } else {
              onTap!(item as M);
            }
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: actions.isNotEmpty,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      padding: EdgeInsets.zero,
                      menuPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      position: PopupMenuPosition.under,
                      // child: Icon(Icons.more_vert_rounded),
                      itemBuilder: (_) => actions,
                    ),
                    const Gap(10),
                  ],
                ),
              ),
              Visibility(
                visible: editable,
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
