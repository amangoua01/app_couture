import 'package:ateliya/data/models/stats/stock_statistiques.dart';
import 'package:ateliya/views/controllers/stats/stock_statistiques_vctl.dart';
import 'package:ateliya/views/static/stats/stock_statistiques_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeCtl extends StockStatistiquesVctl {
  @override
  void onReady() {}
}

StockStatistiques _data() => StockStatistiques.fromJson({
  'kpis': {
    'stockActuelTotal': 26,
    'nbModelesBoutique': 2,
    'nbModelesSansStock': 1,
    'nbMouvementsTotal': 3,
    'nbEntrees': 2,
    'nbSorties': 1,
    'qteEntreeTotale': 30,
    'qteSortieTotale': 4,
    'soldeNet': 26,
    'nbMouvementsEnAttente': 1,
  },
  'evolution': [
    {'date': '2026-11-10', 'qteEntree': 18, 'qteSortie': 0, 'solde': 18},
    {'date': '2026-11-12', 'qteEntree': 8, 'qteSortie': 2, 'solde': 24},
  ],
  'stockParModele': [
    {
      'modeleId': 1,
      'libelle': 'Robe wax',
      'stockTotal': 18,
      'nbVariantes': 1,
      'variantes': [
        {'modeleBoutiqueId': 1, 'taille': '', 'couleur': 'Bleu', 'prix': '25000', 'stock': 18},
      ],
    },
    {
      'modeleId': 2,
      'libelle': 'Boubou brodé',
      'stockTotal': 8,
      'nbVariantes': 1,
      'variantes': [
        {'modeleBoutiqueId': 2, 'taille': 'L', 'couleur': '', 'prix': '25000', 'stock': 8},
      ],
    },
  ],
  'stockParTaille': [
    {'taille': 'L', 'stockTotal': 8, 'nbModeleBoutique': 1},
    {'taille': '', 'stockTotal': 18, 'nbModeleBoutique': 1},
  ],
  'historiqueMouvements': [
    {
      'mouvementId': 5,
      'date': '2026-11-12T16:10:00+00:00',
      'type': 'ENTREE',
      'statut': 'CONFIRME',
      'commentaire': 'Ravitaillement',
      'lignes': [
        {'modeleBoutiqueId': 1, 'modeleLibelle': 'Robe wax', 'taille': '', 'quantiteMouvement': 18, 'quantiteAvant': 0, 'quantiteApres': 18},
      ],
    },
    {
      'mouvementId': 6,
      'date': '2026-11-12T17:10:00+00:00',
      'type': 'SORTIE',
      'statut': 'EN_ATTENTE',
      'lignes': [],
    },
  ],
});

void main() {
  testWidgets('suivi de stock : quatre onglets sans erreur', (t) async {
    t.view.physicalSize = const Size(1080, 2400);
    t.view.devicePixelRatio = 2.6;
    addTearDown(t.view.reset);
    final erreurs = <String>[];
    final ancien = FlutterError.onError;
    FlutterError.onError = (d) {
      final infos = d.informationCollector?.call().map((n) => n.toString()).where((l) => l.contains('creator') || l.contains('Row') || l.contains('Column')).take(3).join(' | ') ?? '';
      erreurs.add('${d.exceptionAsString().split("\n").first} @ $infos');
    };

    final ctl = _FakeCtl()
      ..data = _data()
      ..isLoading = false;
    Get.put<StockStatistiquesVctl>(ctl);
    addTearDown(Get.reset);
    await t.pumpWidget(const GetMaterialApp(home: StockStatistiquesPage()));
    await t.pump(const Duration(seconds: 2));
    try {
    for (final onglet in ['Mouvements', 'Inventaire', 'Par taille', 'Général']) {
      await t.tap(find.text(onglet).first);
      await t.pump(const Duration(seconds: 1));
    }
    // Balayage entre onglets.
    await t.fling(find.byType(TabBarView), const Offset(-400, 0), 1500);
    await t.pump(const Duration(seconds: 1));
    } finally {
      FlutterError.onError = ancien;
    }
    // ignore: avoid_print
    if (erreurs.isNotEmpty) print(erreurs.join('\n---\n'));
    expect(erreurs, isEmpty);
    expect(find.text('Suivi de stock'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 90)));
}
