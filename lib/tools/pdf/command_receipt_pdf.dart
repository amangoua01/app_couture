import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CommandReceiptPdf {
  static Future<void> generate(Mesure mesure) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Reçu de Commande',
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text('#${mesure.id ?? "N/A"}',
                        style: const pw.TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Atelier:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(mesure.succursale?.libelle ?? "Atelier"),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Client:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(mesure.client?.fullName ?? "Client Inconnu"),
                      if (mesure.client?.tel != null)
                        pw.Text(mesure.client!.tel!),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Date: ${mesure.createdAt?.toString().substring(0, 10) ?? "N/A"}'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight
                },
                data: <List<String>>[
                  <String>['Article', 'Montant'],
                  ...mesure.lignesMesures.map(
                    (lm) => [
                      lm.typeMesure?.libelle?.value ?? "Article",
                      lm.montant.toAmount(unit: 'FCFA'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                          'Total: ${mesure.montantTotal.toAmount(unit: "FCFA")}',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 16)),
                      pw.Text(
                          'Avance: ${mesure.avance.toAmount(unit: "FCFA")}'),
                      pw.Text(
                          'Reste: ${mesure.resteArgent.toAmount(unit: "FCFA")}',
                          style: const pw.TextStyle(color: PdfColors.red)),
                    ],
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Center(child: pw.Text("Merci de votre confiance !")),
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }
}
