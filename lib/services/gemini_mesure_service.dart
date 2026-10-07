import 'dart:async';
import 'dart:convert';
import 'package:ateliya/tools/constants/env.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/type_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:ateliya/data/models/categorie_mesure.dart';

class GeminiMesureService {
  static final GeminiMesureService _instance = GeminiMesureService._internal();
  factory GeminiMesureService() => _instance;
  GeminiMesureService._internal();

  static const List<String> _modelsToTry = [
    'gemini-3.5-flash',
    'gemini-3.5-flash-lite',
  ];

  static const _requestTimeout = Duration(seconds: 10);

  /// Les modèles sont interrogés en parallèle (voir
  /// [GeminiAssistantService]) : le premier à répondre avec un résultat
  /// exploitable l'emporte, au lieu d'attendre l'échec du premier avant de
  /// tenter le second.
  Future<LigneMesureDto?> extractMesureFromText(
    String userQuery, {
    List<String>? expectedCategories,
  }) async {
    if (userQuery.trim().isEmpty) return null;

    String categoriesInstruction = "";
    if (expectedCategories != null && expectedCategories.isNotEmpty) {
      categoriesInstruction =
          "\n- Pour le champ 'cle' des mensurations, utilise EXACTEMENT (sans modifier) une de ces clés disponibles si elle correspond : ${expectedCategories.join(', ')}";
    }

    final systemPrompt = '''
Tu es un assistant IA spécialisé pour un atelier de couture.
L'artisan va te dicter les mesures d'un vêtement pour un client (ex: "Pantalon taille 42, longueur 100").
Renvoie STRICTEMENT un objet JSON (sans bloc markdown) avec:
- libelle: (ex: "Pantalon", "Robe")
- type_mesure_nom: (nom du modèle si précisé, sinon null)
- mensurations: (un tableau d'objets avec "cle" et "valeur", ex: [{"cle": "Taille", "valeur": "42"}])$categoriesInstruction
''';

    final prompt = '$systemPrompt\nTexte de l\'utilisateur : "$userQuery"';

    return _raceFirstSuccess(
      _modelsToTry.map(
        (model) => _callModel(model, prompt).then(_toLigneMesure),
      ),
    );
  }

  LigneMesureDto? _toLigneMesure(Map<String, dynamic>? jsonResult) {
    if (jsonResult == null) return null;

    final lm = LigneMesureDto();
    final libelle = jsonResult['libelle']?.toString() ?? 'Article';
    lm.typeMesureDto = TypeMesureDto(id: 0, libelle: libelle);

    if (jsonResult['mensurations'] != null) {
      final list = jsonResult['mensurations'] as List;
      lm.typeMesureDto!.mensurations =
          list
              .map(
                (e) => MensurationDto(
                  categorieMesure: CategorieMesure(
                    id: 0,
                    libelle: e['cle']?.toString(),
                  ),
                  valeur: e['valeur']?.toString() ?? '0',
                ),
              )
              .toList();
    }

    return lm;
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
                'maxOutputTokens': 512,
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
        debugPrint('Gemini API ($model) status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Gemini API error ($model): $e');
    }
    return null;
  }

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
