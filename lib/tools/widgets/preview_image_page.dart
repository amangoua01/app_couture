import 'dart:io';

import 'package:app_couture/tools/widgets/placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PreviewImagePage extends StatelessWidget {
  final String image;
  const PreviewImagePage(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: InteractiveViewer(
          child: PlaceholderWidget(
            condition: image.startsWith("http"),
            placeholder: Image.file(File(image)),
            child: Image.network(image),
          ),
        ),
      ),
    );
  }
}
