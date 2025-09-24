import 'package:app_couture/views/static/clients/edition_client_page.dart';
import 'package:flutter/material.dart';
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
        itemBuilder: (_, i) => const ListTile(
          leading: CircleAvatar(),
          title: Text("Parfait koné"),
          subtitle: Text("07 89 89 10 38 • Eden SARL"),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
          ),
        ),
      ),
    );
  }
}
