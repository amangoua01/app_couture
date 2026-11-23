import 'package:ateliya/services/assistant_speech_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AssistantSpeechService.toSpokenText', () {
    test('retire le gras et les puces', () {
      const texte = "Voici vos articles :\n- **Chemise** (taille L) : 0 pièce\n- **Parfum** : 2 pièces";
      expect(
        AssistantSpeechService.toSpokenText(texte),
        "Voici vos articles :. Chemise (taille L) : 0 pièce. Parfum : 2 pièces",
      );
    });

    test('dit la devise en toutes lettres', () {
      expect(
        AssistantSpeechService.toSpokenText("Votre chiffre d'affaires est de **125 000 XOF**."),
        "Votre chiffre d'affaires est de 125 000 francs CFA.",
      );
      expect(AssistantSpeechService.toSpokenText("Solde : 5 000 FCFA"), "Solde : 5 000 francs CFA");
    });

    test("n'altère pas un mot qui contient XOF", () {
      expect(AssistantSpeechService.toSpokenText("PROXOFIT"), "PROXOFIT");
    });

    test('regroupe les sauts de ligne et espaces', () {
      expect(AssistantSpeechService.toSpokenText("Bonjour\n\n\nMerci   beaucoup"), "Bonjour. Merci beaucoup");
    });

    test('texte vide', () {
      expect(AssistantSpeechService.toSpokenText("  "), "");
    });
  });
}
