import 'package:ateliya/tools/widgets/swipe_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('balayer change d\'onglet dans les deux sens, sans dépasser les bornes', (t) async {
    var courant = 1;
    await t.pumpWidget(MaterialApp(
      home: StatefulBuilder(
        builder: (context, setState) => Scaffold(
          body: SwipeTabs<int>(
            values: const [0, 1, 2],
            selection: courant,
            onChanged: (v) => setState(() => courant = v),
            child: Center(child: Text('onglet $courant')),
          ),
        ),
      ),
    ));
    expect(find.text('onglet 1'), findsOneWidget);

    // Vers la gauche -> onglet suivant
    await t.fling(find.byType(SwipeTabs<int>), const Offset(-300, 0), 1200);
    await t.pumpAndSettle();
    expect(courant, 2);
    expect(find.text('onglet 2'), findsOneWidget);

    // Encore vers la gauche : déjà au dernier onglet, rien ne change
    await t.fling(find.byType(SwipeTabs<int>), const Offset(-300, 0), 1200);
    await t.pumpAndSettle();
    expect(courant, 2);

    // Vers la droite x2 -> premier onglet
    await t.fling(find.byType(SwipeTabs<int>), const Offset(300, 0), 1200);
    await t.pumpAndSettle();
    await t.fling(find.byType(SwipeTabs<int>), const Offset(300, 0), 1200);
    await t.pumpAndSettle();
    expect(courant, 0);
    expect(find.text('onglet 0'), findsOneWidget);

    // Un petit mouvement lent ne déclenche rien
    await t.drag(find.byType(SwipeTabs<int>), const Offset(-40, 0));
    await t.pumpAndSettle();
    expect(courant, 0);
  });
}
