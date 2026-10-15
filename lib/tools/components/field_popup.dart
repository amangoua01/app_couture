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
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
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

  /// Sélecteur en feuille, le « select2 » de l'app : titre, recherche
  /// immédiate, état vide et chargement soignés, élément choisi mis en avant.
  ///
  /// Le délai de recherche par défaut du package est d'une seconde : on la
  /// ramène à un instant pour que la liste suive la frappe.
  static PopupProps<T> bottomSheet<T>({
    DropdownSearchPopupItemBuilder<T>? itemBuilder,
    bool showSearchBox = true,
    String searchHint = "Rechercher...",
    String? title,
    String emptyLabel = "Aucun résultat",
    String? emptyHint,
  }) => PopupProps<T>.modalBottomSheet(
    title:
        title == null
            ? null
            : Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
    fit: FlexFit.loose,
    showSearchBox: showSearchBox,
    itemBuilder: itemBuilder,
    showSelectedItems: true,
    searchDelay: const Duration(milliseconds: 150),
    constraints: const BoxConstraints(maxHeight: 520),
    emptyBuilder:
        (_, __) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 40,
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
              const SizedBox(height: 10),
              Text(
                emptyLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              if (emptyHint != null) ...[
                const SizedBox(height: 4),
                Text(
                  emptyHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
        ),
    loadingBuilder:
        (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        ),
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        hintText: searchHint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.primary.withValues(alpha: 0.04),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    modalBottomSheetProps: const ModalBottomSheetProps(
      backgroundColor: Colors.white,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
  );
}
