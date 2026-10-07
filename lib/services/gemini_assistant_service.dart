import 'dart:async';
import 'dart:convert';
import 'package:ateliya/tools/constants/env.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DepenseExtractionResult {
  final int? montant;
  final String? description;
  final String? suggestionCategorie;
  final String? caisse;

  DepenseExtractionResult({
    this.montant,
    this.description,
    this.suggestionCategorie,
    this.caisse,
  });

  factory DepenseExtractionResult.fromJson(Map<String, dynamic> json) {
    int? parsedMontant;
    final rawMontant = json['montant'];
    if (rawMontant is num) {
      parsedMontant = rawMontant.toInt();
    } else if (rawMontant is String) {
      parsedMontant = int.tryParse(
        rawMontant.replaceAll(RegExp(r'[^0-9]'), ''),
      );
    }

    return DepenseExtractionResult(
      montant: parsedMontant,
      description: json['description']?.toString(),
      suggestionCategorie: json['suggestion_categorie']?.toString(),
      caisse: json['caisse']?.toString(),
    );
  }
}

class GeminiAssistantService {
  static final GeminiAssistantService _instance =
      GeminiAssistantService._internal();
  factory GeminiAssistantService() => _instance;
  GeminiAssistantService._internal();

  static const List<String> _modelsToTry = [
    'gemini-3.5-flash',
    'gemini-3.5-flash-lite',
  ];

  static const _requestTimeout = Duration(seconds: 10);

  /// Analyse une phrase libre (saisie ou dictée) pour en extraire une dépense.
  ///
  /// Les modèles sont interrogés en parallèle plutôt qu'en repli séquentiel :
  /// avant, un modèle en erreur ajoutait un aller-retour réseau complet
  /// avant même de tenter le suivant, doublant le pire cas de latence. Ici,
  /// le résultat retenu est celui du premier modèle qui répond avec succès.
  Future<DepenseExtractionResult?> extractDepenseFromText(
    String userQuery,
  ) async {
    if (userQuery.trim().isEmpty) return null;

    const systemPrompt = '''
Tu es un assistant IA spécialisé dans la gestion d'un atelier de couture (Ateliya).
L'artisan va te dicter ou t'écrire une dépense effectuée.
Extrais les informations de la dépense avec précision.
Renvoie STRICTEMENT ET UNIQUEMENT un objet JSON valide sans formatage markdown (sans ```json) avec les clés suivantes :
- montant: (nombre entier en FCFA, ex: 15000)
- description: (texte court, élégant et précis du motif de la dépense)
- suggestion_categorie: (une suggestion parmi: "Fournitures", "Loyer", "Factures", "Entretien", "Salaires", "Transport", "Divers")
- caisse: (nom de la caisse ou mode de paiement mentionné ex: "Caisse principale", "Espèces", "Wave", "Orange Money", sinon null)
''';

    final prompt = '$systemPrompt\nTexte de l\'utilisateur : "$userQuery"';

    return _raceFirstSuccess(
      _modelsToTry.map(
        (model) => _callModel(model, prompt).then(
          (json) =>
              json == null ? null : DepenseExtractionResult.fromJson(json),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _callModel(String model, String prompt) async {
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=${Env.geminiApiKey}',
      );

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt},
                  ],
                },
              ],
              'generationConfig': {
                'responseMimeType': 'application/json',
                // Réponse courte et attendue : pas besoin de laisser le
                // modèle "réfléchir" longtemps pour un simple objet JSON.
                'maxOutputTokens': 256,
              },
            }),
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final candidates = decoded['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final contentParts = candidates[0]['content']?['parts'] as List?;
          if (contentParts != null && contentParts.isNotEmpty) {
            final rawText = contentParts[0]['text']?.toString() ?? '{}';
            final cleaned =
                rawText.replaceAll('```json', '').replaceAll('```', '').trim();
            return jsonDecode(cleaned) as Map<String, dynamic>;
          }
        }
      } else {
        debugPrint(
          'Gemini API ($model) status: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Gemini API error ($model): $e');
    }
    return null;
  }

  /// Lance tous les [futures] simultanément et retient le premier résultat
  /// non-null ; ne répond `null` que si tous ont échoué ou n'ont rien trouvé.
  Future<T?> _raceFirstSuccess<T>(Iterable<Future<T?>> futures) {
    final completer = Completer<T?>();
    final list = futures.toList();
    var remaining = list.length;

    if (remaining == 0) return Future.value(null);

    for (final future in list) {
      future
          .then((value) {
            if (value != null && !completer.isCompleted) {
              completer.complete(value);
            }
          })
          .catchError((_) {})
          .whenComplete(() {
            remaining--;
            if (remaining == 0 && !completer.isCompleted) {
              completer.complete(null);
            }
          });
    }

    return completer.future;
  }
}
