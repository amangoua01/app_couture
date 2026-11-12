import 'dart:convert';
import 'dart:io';

import 'package:ateliya/data/models/stats/statistiques_boutique.dart';
import 'package:ateliya/views/controllers/home/statistique_page_vctl.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/atelier/atelier_stats_sub_page.dart';
import 'package:ateliya/views/static/home/sub_pages/stats/boutique/boutique_stats_sub_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeVctl extends StatistiquePageVctl {
  @override
  void onReady() {}
}

StatistiquesBoutique _load(String periode) => StatistiquesBoutique.fromJson(
      jsonDecode(File('test/fixtures/stats_boutique_$periode.json').readAsStringSync()),
    );

void main() {
  for (final periode in ['jour', 'mois', 'annee']) {
    for (final atelier in [false, true]) {
      testWidgets('page ${atelier ? 'atelier' : 'boutique'} / $periode', (t) async {
        t.view.physicalSize = const Size(1080, 2400);
        t.view.devicePixelRatio = 2.6;
        addTearDown(t.view.reset);

        final erreurs = <String>[];
        final ancien = FlutterError.onError;
        FlutterError.onError = (d) {
          erreurs.add(d.exceptionAsString());
          for (final n in d.informationCollector?.call() ?? <DiagnosticsNode>[]) {
            final l = n.toString();
            if (l.contains('debugCreator')) erreurs.add(l.split('\n').first);
          }
        };

        const index = {'jour': 0, 'mois': 1, 'annee': 2};
        final ctl = _FakeVctl()..seed(index[periode]!, _load(periode));
        await t.pumpWidget(GetMaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                Expanded(
                  child: atelier
                      ? AtelierStatsSubPage(ctl, periodIndex: index[periode]!)
                      : BoutiqueStatsSubPage(ctl, periodIndex: index[periode]!),
                ),
              ]),
            ),
          ),
        ));
        await t.pump(const Duration(seconds: 2));
        t.takeException();
        FlutterError.onError = ancien;
        expect(erreurs, isEmpty, reason: erreurs.join('\n'));
      });
    }
  }
}
