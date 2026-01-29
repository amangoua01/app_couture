import 'package:ateliya/tools/components/field_border.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CTextFormField extends StatelessWidget {
  final bool autofocus;
  final bool require;
  final int? minLines;
  final int? maxLines;
  final bool? enabled;
  final int? maxLength;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final String? requireText;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? margin;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final TextAlign textAlign;
  final String obscuringCharacter;
  final TextStyle? style;
  final bool? filled;
  final Color? fillColor;
  final Widget? label;
  final Widget? prefix;
  final Widget? suffix;
  final String? initialValue;
  final void Function()? onTap;
  final InputBorder? border;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final String? counterText;
  final void Function(String)? onChanged;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? externalLabel;

  const CTextFormField({
    this.margin = const EdgeInsets.only(bottom: 20),
    this.textInputAction,
    this.externalLabel,
    this.suffixIcon,
    this.prefixIcon,
    this.label,
    this.require = false,
    this.onChanged,
    this.enabled,
    this.hintText,
    this.maxLines = 1,
    this.suffix,
    this.prefix,
    this.minLines,
    this.labelText,
    this.validator,
    this.maxLength,
    this.controller,
    this.labelStyle,
    this.counterText = "",
    this.obscureText = false,
    this.requireText = "Ce champ est obligatoire",
    this.keyboardType,
    this.contentPadding = const EdgeInsets.all(17),
    this.autofocus = false,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.obscuringCharacter = '•',
    this.style,
    this.fillColor = Colors.white,
    this.filled = true,
    super.key,
    this.initialValue,
    this.onTap,
    this.border,
    this.errorBorder,
    this.disabledBorder,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: externalLabel != null,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 3),
              child: Text(
                externalLabel == null
                    ? ''
                    : ((externalLabel.value.isEmpty)
                        ? ""
                        : externalLabel! + (require ? "*" : "")),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextFormField(
            maxLines: maxLines,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLength: maxLength,
            minLines: minLines,
            enabled: enabled,
            readOnly: readOnly,
            initialValue: initialValue,
            textCapitalization: textCapitalization,
            onTap: onTap,
            autofocus: autofocus,
            textAlign: textAlign,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            obscuringCharacter: obscuringCharacter,
            textInputAction: textInputAction,
            validator: (text) {
              if (validator != null) return validator!(text);
              if (require && text.value.isEmpty) return requireText;
              return null;
            },
            style: style,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              prefix: prefix,
              hintText: hintText == null
                  ? null
                  : ((hintText.value.isEmpty)
                      ? ""
                      : hintText! + (require ? "*" : "")),
              suffix: suffix,
              counterText: counterText,
              labelText: labelText == null
                  ? null
                  : (labelText.value.isEmpty
                      ? ""
                      : labelText! + (require ? "*" : "")),
              label: label,
              contentPadding: contentPadding,
              border: border ?? FieldBorder.enabled,
              enabledBorder: border ?? FieldBorder.enabled,
              errorBorder: errorBorder ?? FieldBorder.error,
              disabledBorder: disabledBorder ?? FieldBorder.disabled,
              fillColor: fillColor,
              filled: filled,
              labelStyle: labelStyle,
            ),
          ),
        ],
      ),
    );
  }
}
