import 'dart:io';

import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/widgets/inputs/c_bottom_image_picker.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CImagePickerField extends StatelessWidget {
  final String label;
  final String? path;
  final void Function(File)? onChanged;
  final bool readOnly;
  final void Function()? onDelete;
  final double? height;

  const CImagePickerField({
    super.key,
    this.readOnly = false,
    required this.label,
    this.path,
    this.onChanged,
    this.onDelete,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 7),
          child: AutoSizeText(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            stepGranularity: 1,
            maxFontSize: 13,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              GestureDetector(
                onTap: ternaryFn(
                  condition: !readOnly && onChanged != null,
                  ifFalse: null,
                  ifTrue: () async {
                    if (onChanged != null) {
                      final file = await CBottomImagePicker.show(
                        image: path,
                        cropImage: true,
                      );
                      if (file != null) {
                        onChanged!(file);
                      }
                    }
                  },
                ),
                child: Container(
                  width: double.infinity,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.fieldBorder),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: PlaceholderBuilder(
                      condition: path != null,
                      placeholder: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.grey.shade400,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                      builder: () => PlaceholderWidget(
                        condition: path!.isURL,
                        placeholder: Image.file(
                          File(path!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        child: Image.network(
                          path!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !readOnly && onDelete != null && path != null,
                child: Positioned(
                  top: 5,
                  right: 5,
                  child: Material(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        if (onDelete != null) {
                          final rep = await CChoiceMessageDialog.show(
                            message:
                                "Voulez-vous vraiment supprimer cette image ?",
                          );
                          if (rep == true) {
                            onDelete!();
                          }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
