import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Permet de fermer le clavier partout dans l'application :
/// - un appui en dehors d'un champ retire le focus ;
/// - sur iOS, les claviers numériques n'ont pas de touche de validation,
///   on affiche donc une barre « Terminé » au-dessus du clavier.
class KeyboardDismisser extends StatelessWidget {
  final Widget child;

  const KeyboardDismisser({required this.child, super.key});

  static bool _needsDoneBar() {
    if (defaultTargetPlatform != TargetPlatform.iOS) return false;
    final context = FocusManager.instance.primaryFocus?.context;
    final type = context
        ?.findAncestorWidgetOfExactType<EditableText>()
        ?.keyboardType;
    return type != null &&
        (type.index == TextInputType.number.index ||
            type.index == TextInputType.phone.index);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final showDoneBar = keyboardHeight > 0 && _needsDoneBar();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          child,
          if (showDoneBar)
            Positioned(
              left: 0,
              right: 0,
              bottom: keyboardHeight,
              child: Material(
                color: const Color(0xFFD1D3D9),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    child: const Text(
                      "Terminé",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
