import 'package:ateliya/tools/components/field_border.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

abstract class FieldPopup {
  static PopupProps<T> menu<T>({
    DropdownSearchPopupItemBuilder<T>? itemBuilder,
    bool showSearchBox = false,
    String searchHint = "Rechercher...",
  }) => PopupProps<T>.menu(
    fit: FlexFit.loose,
    constraints: const BoxConstraints(maxHeight: 320),
    itemBuilder: itemBuilder,
    showSearchBox: showSearchBox,
    searchFieldProps:
        showSearchBox
            ? TextFieldProps(
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                ),
                filled: true,
                fillColor: AppColors.primary.withValues(alpha: 0.04),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            )
            : const TextFieldProps(),
    menuProps: MenuProps(
      backgroundColor: Colors.white,
      elevation: 6,
      borderRadius: BorderRadius.circular(20),
      margin: const EdgeInsets.only(top: 8),
      clipBehavior: Clip.antiAlias,
    ),
  );

  static PopupPropsMultiSelection<T> multiMenu<T>() =>
      PopupPropsMultiSelection<T>.menu(
        fit: FlexFit.loose,
        constraints: const BoxConstraints(maxHeight: 320),
        menuProps: MenuProps(
          backgroundColor: Colors.white,
          elevation: 6,
          borderRadius: BorderRadius.circular(20),
          margin: const EdgeInsets.only(top: 8),
          clipBehavior: Clip.antiAlias,
        ),
      );

  static PopupProps<T> bottomSheet<T>({
    DropdownSearchPopupItemBuilder<T>? itemBuilder,
    bool showSearchBox = true,
    String searchHint = "Rechercher...",
  }) => PopupProps<T>.modalBottomSheet(
    showSearchBox: showSearchBox,
    itemBuilder: itemBuilder,
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        hintText: searchHint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.primary.withValues(alpha: 0.04),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    modalBottomSheetProps: const ModalBottomSheetProps(
      backgroundColor: Colors.white,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
  );
}
