import 'package:flutter/material.dart';

class AbonnementPaymentPage extends StatelessWidget {
  const AbonnementPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finalisation")),
      body: const Center(
        child: Text("Page de paiement d'abonnement"),
      ),
    );
  }
}
