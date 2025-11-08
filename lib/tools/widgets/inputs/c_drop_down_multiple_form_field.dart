import 'dart:async';

import 'package:app_couture/tools/components/field_border.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CDropDownMultipleFormField<T> extends StatelessWidget {
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputBorder? border;
  final TextEditingController? controller;
  final bool require;
  final String? hintText;
  final EdgeInsetsGeometry? margin;
  final void Function(List<T>)? onChanged;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? baseStyle;
  final List<T> selectedItems;
  final bool enabled;
  final String Function(T)? itemAsString;
  final Future<List<T>> Function()? asyncItems;
  final PopupPropsMultiSelection<T> popupProps;
  final bool Function(T, T)? compareFn;
  final bool Function(T, String)? filterFn;
  final FutureOr<List<T>> Function(String, LoadProps?)? items;
  final String? Function(List<T>?)? validator;
  final Color fillColor;
  final String? externalLabel;

  const CDropDownMultipleFormField(
      {this.controller,
      this.baseStyle,
      this.externalLabel,
      this.fillColor = Colors.white,
      this.validator,
      this.contentPadding = const EdgeInsets.all(10),
      this.filterFn,
      this.compareFn,
      this.selectedItems = const [],
      this.asyncItems,
      this.enabled = true,
      this.itemAsString,
      this.popupProps = const PopupPropsMultiSelection.menu(),
      this.items,
      this.maxLines = 1,
      this.onChanged,
      this.margin = const EdgeInsets.only(bottom: 10),
      this.border,
      this.require = false,
      this.prefixIcon,
      this.suffixIcon,
      this.labelText,
      this.hintText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          Visibility(
            visible: externalLabel != null,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                externalLabel == null
                    ? ''
                    : ((externalLabel.value.isEmpty)
                        ? ""
                        : externalLabel! + (require ? "*" : "")),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ),
          DropdownSearch<T>.multiSelection(
            onChanged: onChanged,
            enabled: enabled,
            filterFn: filterFn,
            itemAsString: itemAsString,
            items: items,
            selectedItems: selectedItems,
            popupProps: popupProps,
            compareFn: compareFn ?? (a, b) => a == b,
            validator: (value) {
              if (validator != null) {
                return validator!(value);
              } else {
                if (require && value == null) {
                  return "Ce champ est obligatoire";
                }
                return null;
              }
            },
            decoratorProps: DropDownDecoratorProps(
              baseStyle: baseStyle,
              decoration: InputDecoration(
                fillColor: fillColor,
                contentPadding: contentPadding,
                suffixIcon: suffixIcon,
                labelText:
                    (require && labelText != null) ? "$labelText*" : labelText,
                hintText:
                    (require && hintText != null) ? "$hintText" : hintText,
                prefixIcon: prefixIcon,
                filled: true,
                errorBorder: border ?? FieldBorder.error,
                focusedBorder: border ?? FieldBorder.enabled,
                enabledBorder: border ?? FieldBorder.enabled,
                border: border ?? FieldBorder.enabled,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
