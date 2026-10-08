import 'package:ateliya/data/models/entreprise.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/pdf/bilan_pdf.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

/// Aperçu en pleine page du bilan généré, avec actions natives de partage
/// et d'impression/export intégrées au widget — pas besoin de quitter
/// l'app pour obtenir le PDF.
class BilanPdfPreviewPage extends StatelessWidget {
  final StatistiquesBoutique data;
  final String periodeLabel;
  final Entreprise? entreprise;

  const BilanPdfPreviewPage({
    super.key,
    required this.data,
    required this.periodeLabel,
    this.entreprise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F2),
      appBar: AppBar(title: const Text("Bilan")),
      body: PdfPreview(
        build:
            (format) => BilanPdf.buildBytes(
              data: data,
              periodeLabel: periodeLabel,
              entreprise: entreprise,
            ),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        pdfFileName:
            "bilan_${periodeLabel.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}.pdf",
        loadingWidget: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}
