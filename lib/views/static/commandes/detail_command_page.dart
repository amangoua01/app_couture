import 'dart:io';

import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/data/models/paiement_facture.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/paiement_dialog.dart';
import 'package:ateliya/views/controllers/commandes/detail_command_page_vctl.dart'; // Added
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart'; // Added
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DetailCommandPage extends StatefulWidget {
  final Mesure? mesure;
  const DetailCommandPage({super.key, this.mesure});

  @override
  State<DetailCommandPage> createState() => _DetailCommandPageState();
}

class _DetailCommandPageState extends State<DetailCommandPage> {
  late Future<void> _initDateFuture;
  Mesure? _mesure;

  @override
  void initState() {
    super.initState();
    _initDateFuture = initializeDateFormatting('fr_FR', null);
    _mesure = widget.mesure;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailCommandPageVctl>(
      init: DetailCommandPageVctl(),
      builder: (ctl) {
        return FutureBuilder(
          future: _initDateFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (_mesure == null) {
              return Scaffold(
                appBar: AppBar(title: const Text("Détail de la commande")),
                body: const Center(child: Text("Aucune commande sélectionnée")),
              );
            }

            final mesure = _mesure!;
            final pourcentage = (mesure.montantTotal > 0)
                ? (mesure.avance / mesure.montantTotal)
                : 0.0;
            final isPaid = pourcentage >= 1.0;

            return Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                title: Text("Commande #${mesure.id ?? ''}"),
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                titleTextStyle: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                iconTheme: const IconThemeData(color: Colors.black87),
                actions: [
                  if (mesure.resteArgent > 0)
                    IconButton(
                      onPressed: () async {
                        final res = await showDialog(
                          context: context,
                          builder: (context) => PaiementDialog(mesure: mesure),
                        );

                        if (res != null && res is Mesure) {
                          setState(() {
                            _mesure = res;
                          });
                        }
                      },
                      icon: const Icon(Icons.payment, color: AppColors.primary),
                      tooltip: "Ajouter un paiement",
                    ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Dates Section
                  _buildCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDateColumn("Dépôt", mesure.dateDepot),
                        Container(
                            width: 1, height: 40, color: Colors.grey[200]),
                        _buildDateColumn("Retrait prévu", mesure.dateRetrait,
                            isHighlight: true),
                      ],
                    ),
                  ),
                  const Gap(15),

                  // Status Card with financial summary
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Progression du paiement",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    (isPaid ? Colors.green : AppColors.primary)
                                        .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${(pourcentage * 100).toInt()}%",
                                style: TextStyle(
                                  color:
                                      isPaid ? Colors.green : AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(15),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: pourcentage,
                            minHeight: 10,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(
                                isPaid ? Colors.green : AppColors.primary),
                          ),
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildAmountColumn(
                                "Avance",
                                mesure.avance.toAmount(unit: "F"),
                                Colors.black87),
                            _buildAmountColumn(
                                "Reste",
                                mesure.resteArgent.toAmount(unit: "F"),
                                Colors.red),
                            _buildAmountColumn(
                                "Total",
                                mesure.montantTotal.toAmount(unit: "F"),
                                AppColors.primary,
                                isBold: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(15),

                  // Client Card
                  _buildSectionTitle("Client"),
                  _buildCard(
                    child: Row(
                      children: [
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: _buildClientAvatar(mesure.client?.photo)),
                        const Gap(15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mesure.client?.fullName ?? "Inconnu",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(mesure.client?.tel ?? "Sans contact",
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(15),

                  // Articles Card
                  _buildSectionTitle("Articles"),
                  ...mesure.lignesMesures.map((lm) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(lm.typeMesure?.libelle ?? "Article",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text(lm.montant.toAmount(unit: "F"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary)),
                                ],
                              ),
                              if (lm.photoModele != null ||
                                  lm.photoPagne != null) ...[
                                const Gap(10),
                                const Divider(),
                                const Gap(10),
                                Row(
                                  children: [
                                    if (lm.photoModele != null) ...[
                                      _buildImageThumb(
                                          lm.photoModele, "Modèle"),
                                      const Gap(10),
                                    ],
                                    if (lm.photoPagne != null)
                                      _buildImageThumb(lm.photoPagne, "Pagne"),
                                  ],
                                )
                              ]
                            ],
                          ),
                        ),
                      )),

                  if (mesure.paiementFactures.isNotEmpty) ...[
                    const Gap(15),
                    _buildSectionTitle("Historique des paiements"),
                    _buildCard(
                      child: Column(
                        children: [
                          ...mesure.paiementFactures
                              .map((p) => _buildPaymentRow(p)),
                        ],
                      ),
                    ),
                  ],

                  const Gap(30),

                  // Action Buttons (Print & PDF)
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CButton(
                          title: 'Imprimer (BT)',
                          color: Colors.black87,
                          icon: const Icon(Icons.print,
                              color: Colors.white, size: 18),
                          onPressed: () => ctl.printReceipt(mesure),
                        ),
                      ),
                      const Gap(15),
                      Expanded(
                        child: CButton(
                          title: 'PDF',
                          icon: const Icon(Icons.picture_as_pdf,
                              color: Colors.white, size: 18),
                          onPressed: () => ctl.exportPdf(mesure),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: child,
    );
  }

  Widget _buildDateColumn(String label, DateTime? date,
      {bool isHighlight = false}) {
    final formattedDate =
        date != null ? DateFormat('dd MMM yyyy', 'fr_FR').format(date) : "--";
    final formattedTime = date != null ? DateFormat('HH:mm').format(date) : "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const Gap(4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(formattedDate,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isHighlight ? AppColors.primary : Colors.black87)),
            if (formattedTime.isNotEmpty) ...[
              const Gap(5),
              Text(formattedTime,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            ]
          ],
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(title,
          style:
              TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAmountColumn(String label, String amount, Color color,
      {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        Text(amount,
            style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600)),
      ],
    );
  }

  Widget _buildImageThumb(Fichier? file, String label) {
    if (file == null) return const SizedBox();

    ImageProvider? imageProvider;
    if (file is FichierServer && file.fullUrl != null) {
      imageProvider = NetworkImage(file.fullUrl!);
    } else if (file is FichierLocal) {
      imageProvider = FileImage(File(file.path));
    }

    if (imageProvider == null) return const SizedBox();

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        const Gap(4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey))
      ],
    );
  }

  Widget _buildClientAvatar(Fichier? photo) {
    if (photo is FichierServer && photo.fullUrl != null) {
      return CircleAvatar(backgroundImage: NetworkImage(photo.fullUrl!));
    }
    return const Icon(Icons.person, color: AppColors.primary);
  }

  Widget _buildPaymentRow(PaiementFacture paiement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  paiement.createdAt != null
                      ? DateFormat('dd MMM yyyy HH:mm', 'fr_FR')
                          .format(paiement.createdAt!)
                      : "--",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text("Ref: ${paiement.reference ?? '-'}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Text(paiement.montant.toAmount(unit: "F"),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }
}
