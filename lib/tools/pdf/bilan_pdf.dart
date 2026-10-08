import 'dart:typed_data';

import 'package:ateliya/data/models/entreprise.dart';
import 'package:ateliya/data/models/fichier_server.dart';
import 'package:ateliya/data/models/stats/kpis.dart';
import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/data/models/stats/top_modele_vendu.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Bilan téléchargeable (période, mois ou année) d'une boutique ou d'un
/// atelier, construit à partir des mêmes données déjà chargées sur l'écran
/// Statistiques — pas de nouvel appel réseau nécessaire.
class BilanPdf {
  static Future<Uint8List> buildBytes({
    required StatistiquesBoutique data,
    required String periodeLabel,
    Entreprise? entreprise,
  }) async {
    pw.ImageProvider? logoImage;
    try {
      if (entreprise?.logo is FichierServer) {
        final url = (entreprise!.logo as FichierServer).fullUrl;
        if (url != null) logoImage = await networkImage(url);
      }
    } catch (_) {
      // Un logo manquant ne doit jamais empêcher la génération du bilan.
    }

    final primaryColor = PdfColor.fromHex('#0A3A30');

    final kpis = data.kpis;
    final isAtelier = kpis.delaiMoyenLivraisonJours != null;
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        header: (context) => _header(
          entreprise: entreprise,
          logoImage: logoImage,
          periodeLabel: periodeLabel,
          primaryColor: primaryColor,
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber}/${context.pagesCount} • Généré par Ateliya',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ),
        build: (context) => [
          pw.SizedBox(height: 20),
          _kpiGrid(kpis, isAtelier, primaryColor),
          pw.SizedBox(height: 24),
          if (data.revenusQuotidiens.isNotEmpty) ...[
            _sectionTitle('Revenus par jour', primaryColor),
            pw.SizedBox(height: 8),
            _revenusTable(data, primaryColor),
            pw.SizedBox(height: 24),
          ],
          if ((data.topModelesVendus ?? []).isNotEmpty) ...[
            _sectionTitle(
              isAtelier ? 'Pièces les plus cousues' : 'Top modèles vendus',
              primaryColor,
            ),
            pw.SizedBox(height: 8),
            _topTable(data, primaryColor),
          ],
          if ((data.comparaisonEntites ?? []).isNotEmpty) ...[
            pw.SizedBox(height: 24),
            _sectionTitle(
              'Charges par ${isAtelier ? "atelier" : "boutique"}',
              primaryColor,
            ),
            pw.SizedBox(height: 8),
            _chargesParEntiteTable(data, isAtelier, primaryColor),
          ],
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _header({
    required Entreprise? entreprise,
    required pw.ImageProvider? logoImage,
    required String periodeLabel,
    required PdfColor primaryColor,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            if (logoImage != null) ...[
              pw.Container(
                width: 50,
                height: 50,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  image: pw.DecorationImage(
                    image: logoImage,
                    fit: pw.BoxFit.cover,
                  ),
                ),
              ),
              pw.SizedBox(width: 14),
            ],
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    (entreprise?.libelle ?? 'ENTREPRISE').toUpperCase(),
                    style: pw.TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Bilan $periodeLabel',
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: primaryColor, thickness: 1.2),
      ],
    );
  }

  static pw.Widget _sectionTitle(String title, PdfColor color) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 13,
        fontWeight: pw.FontWeight.bold,
        color: color,
      ),
    );
  }

  /// Une couleur par KPI (plutôt qu'une grille monochrome) : la couleur
  /// porte elle-même un sens (vert = argent qui rentre, rouge = qui sort,
  /// orange = à surveiller), ce qui rend le bilan plus lisible d'un coup
  /// d'œil et plus présentable qu'un tableau gris uniforme.
  static pw.Widget _kpiGrid(
    Kpis kpis,
    bool isAtelier,
    PdfColor primaryColor,
  ) {
    final vert = PdfColor.fromHex('#16A34A');
    final rouge = PdfColor.fromHex('#DC2626');
    final bleu = PdfColor.fromHex('#2563EB');
    final violet = PdfColor.fromHex('#7C3AED');
    final teal = PdfColor.fromHex('#0D9488');
    final indigo = PdfColor.fromHex('#4F46E5');
    final ambre = PdfColor.fromHex('#D97706');

    final tiles = <(String, String, PdfColor)>[
      ('Chiffre d\'affaires', '${kpis.chiffreAffaires.toAmount()} FCFA', vert),
      ('Recettes nettes', '${(kpis.recettesNettes ?? 0).toAmount()} FCFA', bleu),
      ('Ticket moyen', '${(kpis.ticketMoyen ?? 0).toAmount()} FCFA', violet),
      ('Dépenses', '${kpis.totalDepenses.toAmount()} FCFA', rouge),
      ('Taux de recouvrement', '${kpis.tauxRecouvrement ?? 0}%', ambre),
      ('Solde caisse', '${kpis.caisse.toAmount()} FCFA', teal),
      if (isAtelier) ...[
        ('Délai moyen de livraison', '${kpis.delaiMoyenLivraisonJours} j', indigo),
        ('Pièces en retard', '${kpis.piecesEnRetard ?? 0}', rouge),
      ],
    ];

    return pw.Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final t in tiles)
          pw.Container(
            width: 160,
            padding: const pw.EdgeInsets.fromLTRB(10, 10, 10, 10),
            // Fond plein (pas une teinte à faible opacité, mal rendue par
            // certains lecteurs PDF) : la couleur ne sert à rien si le
            // texte de la même teinte devient illisible dessus — on passe
            // donc le texte en blanc.
            decoration: pw.BoxDecoration(
              color: t.$3,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  t.$1,
                  style: pw.TextStyle(
                    fontSize: 8.5,
                    color: PdfColor(1, 1, 1, 0.8),
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  t.$2,
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static pw.Widget _revenusTable(
    StatistiquesBoutique data,
    PdfColor primaryColor,
  ) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 9,
      ),
      headerDecoration: pw.BoxDecoration(color: primaryColor),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {1: pw.Alignment.centerRight},
      headers: const ['Jour', 'Revenus (FCFA)'],
      data: [
        for (final r in data.revenusQuotidiens)
          [r.jour ?? '-', r.revenus.toInt().toAmount()],
      ],
    );
  }

  static pw.Widget _topTable(
    StatistiquesBoutique data,
    PdfColor primaryColor,
  ) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 9,
      ),
      headerDecoration: pw.BoxDecoration(color: primaryColor),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {1: pw.Alignment.center, 2: pw.Alignment.centerRight},
      headers: const ['Nom', 'Quantité', 'Revenus (FCFA)'],
      data: [
        // `?? []` (non typé) dans un for-in casse l'inférence de type de la
        // variable de boucle (elle devient `dynamic`), ce qui fait planter
        // les méthodes d'extension comme `.toAmount()` à l'exécution —
        // d'où le type explicite `<TopModeleVendu>[]` ici.
        for (final m in data.topModelesVendus ?? <TopModeleVendu>[])
          [m.nom ?? '-', '${m.ventes ?? 0}', (m.revenus ?? 0).toAmount()],
      ],
    );
  }

  static pw.Widget _chargesParEntiteTable(
    StatistiquesBoutique data,
    bool isAtelier,
    PdfColor primaryColor,
  ) {
    final entites = (data.comparaisonEntites ?? [])
        .where((e) => isAtelier ? !e.isBoutique : e.isBoutique)
        .toList()
      ..sort((a, b) => b.totalDepenses.compareTo(a.totalDepenses));

    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 9,
      ),
      headerDecoration: pw.BoxDecoration(color: primaryColor),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {1: pw.Alignment.centerRight},
      headers: [isAtelier ? 'Atelier' : 'Boutique', 'Charges (FCFA)'],
      data: [
        for (final e in entites)
          [e.nom ?? '-', e.totalDepenses.toAmount()],
      ],
    );
  }
}
