import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
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
          builder: () => _buildLeadingCircle(),
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
              child: _buildLeadingCircle(),
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

  /// Cercle leading unifié, utilisé dans ListTile et CheckboxListTile.
  Widget _buildLeadingCircle() {
    final src = leadingImage.value;
    return Container(
      width: 45,
      height: 45,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: ClipOval(child: _buildLeadingContent(src)),
    );
  }

  Widget _buildLeadingContent(String src) {
    // 1. Lottie (.json)
    if (src.endsWith('.json')) {
      return Lottie.asset(src);
    }
    // 2. Image réseau (http / https)
    if (src.startsWith('http')) {
      return Image.network(
        src,
        width: leadingImageSize,
        height: leadingImageSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
          'assets/images/svg/image_broken.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          fit: BoxFit.cover,
          width: leadingImageSize,
          height: leadingImageSize,
        ),
      );
    }
    // 3. SVG asset
    if (src.endsWith('.svg')) {
      return SvgPicture.asset(
        src,
        width: leadingImageSize,
        height: leadingImageSize,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        fit: BoxFit.contain,
      );
    }
    // 4. Image asset classique (png, jpg…)
    return Image.asset(
      src,
      width: leadingImageSize,
      height: leadingImageSize,
      color: Colors.white,
      fit: BoxFit.contain,
    );
  }
}
