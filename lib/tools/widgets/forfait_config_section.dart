import 'package:app_couture/tools/widgets/text_divider.dart';
import 'package:flutter/material.dart';

class ForfaitConfigSection extends StatelessWidget {
  final String title;
  const ForfaitConfigSection({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextDivider(title),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) => CheckboxListTile(
              title: Text("Option ${i + 1}"),
              value: false,
              onChanged: (e) {},
            ),
            separatorBuilder: (_, i) => const Divider(
              thickness: 2,
              height: 0,
            ),
            itemCount: 3,
          ),
        ],
      ),
    );
  }
}
