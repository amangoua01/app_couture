import 'dart:convert';
import 'dart:io';

import 'package:ateliya/data/models/stats/globale_stats.dart';
import 'package:ateliya/views/controllers/home/statistique_entreprise_page_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/statistique_entreprise_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeVctl extends StatistiqueEntreprisePageVctl {
  @override
  void onReady() {}
}

GlobaleStats _g(String periode) {
  final b = jsonDecode(File('test/fixtures/stats_boutique_$periode.json').readAsStringSync());
  return GlobaleStats.fromJson({
    'boutiques': b,
    'ateliers': b,
    'precedent': {'boutiques': b['kpis'], 'ateliers': b['kpis']},
    'comparaisonEntites': [
      {'id': 1, 'nom': 'Boutique A', 'type': 'boutique', 'chiffreAffaires': 5000, 'totalDepenses': 100},
      {'id': 2, 'nom': 'Atelier B', 'type': 'succursale', 'chiffreAffaires': 3000, 'totalDepenses': 50},
    ],
  });
}

void main() {
  for (final periode in ['jour', 'mois', 'annee']) {
    for (final scope in [0, 1, 2]) {
      testWidgets('globale $periode / filtre $scope', (t) async {
        t.view.physicalSize = const Size(1080, 2400);
        t.view.devicePixelRatio = 2.6;
        addTearDown(t.view.reset);
        final erreurs = <String>[];
        final ancien = FlutterError.onError;
        FlutterError.onError = (d) => erreurs.add(d.exceptionAsString());

        const index = {'jour': 0, 'mois': 1, 'annee': 2};
        final ctl = _FakeVctl()
          ..seed(index[periode]!, _g(periode))
          ..scope = scope;
        await t.pumpWidget(GetMaterialApp(
          home: Scaffold(body: GlobaleStatsView(ctl, periodIndex: index[periode]!)),
        ));
        await t.pump(const Duration(seconds: 2));
        FlutterError.onError = ancien;
        expect(erreurs, isEmpty);
        expect(find.byType(GlobaleStatsView), findsOneWidget);
      });
    }
  }
}
