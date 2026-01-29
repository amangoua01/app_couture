import 'dart:io';

import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/widgets/inputs/c_bottom_image_picker.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CImagePickerField extends StatelessWidget {
  final String label;
  final String? path;
  final void Function(File)? onChanged;
  final bool readOnly;
  final void Function()? onDelete;

  const CImagePickerField({
    super.key,
    this.readOnly = false,
    required this.label,
    this.path,
    this.onChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(label),
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
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: PlaceholderBuilder(
                    condition: path != null,
                    placeholder: const Icon(Icons.image, color: Colors.grey),
                    builder: () => PlaceholderWidget(
                      condition: path!.isURL,
                      placeholder: Image.file(File(path!)),
                      child: Image.network(path!),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !readOnly && onDelete != null && path != null,
                child: Positioned(
                  top: 7,
                  right: 7,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 15,
                      ),
                      onPressed: () async {
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
