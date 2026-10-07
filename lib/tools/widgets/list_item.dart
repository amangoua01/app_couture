import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/preview_image_page.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

/// Ligne de liste utilisée par la quasi-totalité des écrans de listes.
///
/// Rendue comme une carte autonome (plutôt qu'une ligne de tableau classique)
/// pour que toutes les listes de l'app partagent le même habillage visuel.
class ListItem<M extends ModelJson> extends StatelessWidget {
  final String title;
  final dynamic subtitle;
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
  final Widget? leadingWidget;
  final Widget? trailing;
  final Color? backgroundColor;
  final double leadingImageSize;

  const ListItem(
    this.ctl, {
    this.leadingImageSize = 30.0,
    this.leadingWidget,
    this.trailing,
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

  bool get _isSelectionMode => ctl.selected != null;

  void _toggleSelection() {
    if (deletable) ctl.onSelect(ctl.data.items[index].id.value);
  }

  Future<void> _handleTap() async {
    if (_isSelectionMode) {
      _toggleSelection();
      return;
    }
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
  }

  @override
  Widget build(BuildContext context) {
    final isChecked = _isSelectionMode && ctl.isSelected(index);

    return Container(
      // La carte vient de la surface qui regroupe toute la liste (voir
      // WrapperListviewFromViewController) ; cette ligne ne porte qu'une
      // teinte quand elle est sélectionnée.
      color:
          (selected || isChecked)
              ? AppColors.primary.withValues(alpha: 0.05)
              : null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          onLongPress: _isSelectionMode ? null : _toggleSelection,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                PlaceholderBuilder(
                  condition: _isSelectionMode,
                  builder:
                      () => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Checkbox(
                          value: isChecked,
                          onChanged:
                              deletable ? (_) => _toggleSelection() : null,
                        ),
                      ),
                ),
                PlaceholderBuilder(
                  condition: leadingWidget != null || leadingImage != null,
                  builder:
                      () => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: leadingWidget ??
                            Badge(
                              label: badgeWidget,
                              backgroundColor: backgroundColor,
                              isLabelVisible: displayBadge,
                              child: _buildLeadingCircle(),
                            ),
                      ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const Gap(3),
                        subtitle is Widget
                            ? subtitle as Widget
                            : Text(
                              subtitle.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textMuted,
                              ),
                            ),
                      ],
                    ],
                  ),
                ),
                if (!_isSelectionMode) ...[
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
                        const Gap(4),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    trailing!,
                  ] else ...[
                    Visibility(
                      visible: editable,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Badge leading unifié : carré arrondi, cohérent avec les icônes des
  /// réglages plutôt qu'un cercle plat.
  Widget _buildLeadingCircle() {
    final src = leadingImage.value;
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primary,
      ),
      // Sans ce ClipRRect centré, l'icône (plus petite que le badge) restait
      // collée en haut à gauche au lieu d'être centrée : sur un badge carré
      // ça se voyait beaucoup plus que sur l'ancien badge rond.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildLeadingContent(src),
      ),
    );
  }

  Widget _buildLeadingContent(String src) {
    // 1. Lottie (.json)
    if (src.endsWith('.json')) {
      return Lottie.asset(src);
    }
    // 2. Image réseau (http / https)
    if (src.startsWith('http')) {
      return GestureDetector(
        onTap: () => Get.to(() => PreviewImagePage(src)),
        child: Image.network(
          src,
          width: leadingImageSize,
          height: leadingImageSize,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => SvgPicture.asset(
                'assets/images/svg/image_broken.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                fit: BoxFit.cover,
                width: leadingImageSize,
                height: leadingImageSize,
              ),
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
