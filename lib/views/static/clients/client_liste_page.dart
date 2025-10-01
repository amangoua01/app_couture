import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/views/static/clients/edition_client_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ClientListePage extends StatelessWidget {
  const ClientListePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clients")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const EditionClientPage()),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemCount: 10,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const ListTile(
            leading: CircleAvatar(),
            title: Text("Parfait koné"),
            subtitle: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 15),
                      Gap(5),
                      Text(
                        "07 89 89 10 38",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.business_outlined,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      Gap(5),
                      Text(
                        "Eden SARL",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
            ),
          ),
        ),
      ),
    );
  }
}
