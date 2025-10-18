import 'package:app_couture/views/static/abonnements/downgrade_selection_option_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatorListPage extends StatelessWidget {
  const OperatorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Opérateurs"),
      ),
      body: GridView(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          'assets/images/moov.png',
          'assets/images/mtn.jpeg',
          'assets/images/orange.png',
          'assets/images/wave.png',
        ]
            .map(
              (e) => GestureDetector(
                onTap: () => Get.to(() => const DowngradeSelectionOptionPage()),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      e,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
