import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyDataWidget extends StatelessWidget {
  final VoidCallback? onRefresh;
  final String message;
  final String? image;
  final String buttonTitle;
  const EmptyDataWidget({
    this.onRefresh,
    this.buttonTitle = "Réessayer",
    this.message = "Aucune donnée trouvée",
    this.image = "assets/images/deco3.png",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlaceholderBuilder(
            condition: image != null,
            builder: () => PlaceholderWidget(
              condition: image.value.contains(".json"),
              placeholder: Image.asset(image.value, width: 200),
              child: Lottie.asset(image.value, width: 200),
            ),
          ),
          ListTile(
            title: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          PlaceholderBuilder(
            condition: onRefresh != null,
            builder: () => TextButton(
              onPressed: onRefresh,
              child: Text(buttonTitle),
            ),
          ),
        ],
      ),
    );
  }
}
