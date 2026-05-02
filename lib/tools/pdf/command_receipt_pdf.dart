import 'package:ateliya/data/models/entreprise.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/data/models/succursale.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CommandReceiptPdf {
  static Future<void> generate(
    Mesure mesure, {
    Entreprise? entreprise,
    Succursale? succursale,
    String? messageExigences,
  }) async {
    pw.ImageProvider? logoImage;
    try {
      if (entreprise?.logo is FichierServer) {
        final url = (entreprise!.logo as FichierServer).fullUrl;
        if (url != null) {
          logoImage = await networkImage(url);
        }
      }
    } catch (e) {
      // Ignore image load error
    }

    var primaryColor = PdfColor.fromHex('#0033A0'); // Blue
    const greyColor = PdfColors.grey200;
    const greenColor = PdfColors.green600;

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoImage != null) ...[
                    pw.Container(
                      width: 60,
                      height: 60,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(
                          image: logoImage,
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 15),
                  ],
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          (entreprise?.libelle ??
                                  succursale?.libelle ??
                                  'ATELIER')
                              .toUpperCase(),
                          style: pw.TextStyle(
                            color: primaryColor,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Adresse : Mali', // Or use succursale address if available
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'Tél: ${succursale?.contact ?? entreprise?.numero ?? ""}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Info Boxes
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Client Box
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(15),
                      decoration: pw.BoxDecoration(
                        color: greyColor,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'FACTURÉ À',
                            style: pw.TextStyle(
                                color: PdfColors.grey700,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            mesure.client?.fullName ?? "Client Inconnu",
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold),
                          ),
                          if (mesure.client?.tel != null) ...[
                            pw.SizedBox(height: 5),
                            pw.Text('Tél: ${mesure.client!.tel!}',
                                style: const pw.TextStyle(fontSize: 10)),
                          ]
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  // Invoice Details Box
                  pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(15),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#E8F4F8'), // Light blue
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('N° Facture:',
                              'INV-${mesure.id.toString().padLeft(6, '0')}'),
                          _buildDetailRow(
                              'Date:',
                              mesure.createdAt?.toString().substring(0, 10) ??
                                  ''),
                          _buildDetailRow(
                              'Livraison prévue:',
                              mesure.dateRetrait?.toString().substring(0, 10) ??
                                  ''),
                          _buildDetailRow(
                              'Statut:', mesure.etatFacture ?? 'En cours'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Title
              pw.Center(
                child: pw.Text(
                  'FACTURE',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              pw.Text(
                'Vêtements',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              // Table
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(2),
                  4: const pw.FlexColumnWidth(2),
                },
                border:
                    pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _buildTableCell('Article', isHeader: true),
                      _buildTableCell('Détails', isHeader: true),
                      _buildTableCell('Qté',
                          isHeader: true, align: pw.TextAlign.center),
                      _buildTableCell('Prix Unit.',
                          isHeader: true, align: pw.TextAlign.right),
                      _buildTableCell('Total',
                          isHeader: true, align: pw.TextAlign.right),
                    ],
                  ),
                  // Table Rows
                  ...mesure.lignesMesures.map((lm) {
                    return pw.TableRow(
                      children: [
                        _buildTableCell(
                            lm.typeMesure?.libelle?.value ?? "Article"),
                        _buildTableCell(lm.nom ?? ""),
                        _buildTableCell('1', align: pw.TextAlign.center),
                        _buildTableCell(lm.montant.toAmount(unit: 'FCFA'),
                            align: pw.TextAlign.right),
                        _buildTableCell(lm.montant.toAmount(unit: 'FCFA'),
                            align: pw.TextAlign.right),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 20),

              // Exigences Box
              if (messageExigences != null && messageExigences.isNotEmpty)
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Exigences spéciales :',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        messageExigences,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              pw.SizedBox(height: 30),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 250,
                    child: pw.Column(
                      children: [
                        _buildTotalRow('Sous-total:',
                            mesure.montantTotal.toAmount(unit: "FCFA")),
                        _buildTotalRow('Acompte versé:',
                            mesure.avance.toAmount(unit: "FCFA"),
                            color: greenColor),
                        pw.Divider(color: PdfColors.black, thickness: 1),
                        _buildTotalRow('Reste à payer:',
                            mesure.resteArgent.toAmount(unit: "FCFA"),
                            color: greenColor, isBold: true),
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),
              pw.Divider(color: PdfColors.black, thickness: 1),
              pw.SizedBox(height: 10),

              // Footer
              pw.Text(
                'Conditions de paiement',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Merci de votre confiance. Cette facture est générée automatiquement.',
                style:
                    const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Date de livraison prévue: ${mesure.dateRetrait?.toString().substring(0, 10) ?? ""}',
                style:
                    const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style:
                  const pw.TextStyle(color: PdfColors.grey700, fontSize: 10)),
          pw.Text(value,
              style:
                  pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildTotalRow(String label, String value,
      {PdfColor? color, bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  fontSize: isBold ? 12 : 10,
                  fontWeight:
                      isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                  color: color ?? PdfColors.black)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: isBold ? 12 : 10,
                  fontWeight:
                      isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                  color: color ?? PdfColors.black)),
        ],
      ),
    );
  }
}
