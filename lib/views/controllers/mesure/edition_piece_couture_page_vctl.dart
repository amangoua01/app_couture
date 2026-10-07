import 'dart:io';

import 'package:ateliya/api/taille_standard_api.dart';
import 'package:ateliya/api/type_mesure_api.dart';
import 'package:ateliya/data/dto/autre_image_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:ateliya/data/dto/mesure/type_mesure_dto.dart';
import 'package:ateliya/data/models/taille_standard.dart';
import 'package:ateliya/data/models/type_mesure.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/extensions/types/text_editing_controller.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ateliya/services/gemini_mesure_service.dart';
import 'package:ateliya/services/speech_recognition_service.dart';
import 'package:ateliya/views/static/mesure/sub_pages/reprendre_mesures_client_page.dart';

class EditionPieceCouturePageVctl extends AuthViewController {
  LigneMesureDto? ligne;
  final nomTenancierCtl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  TypeMesure? selectedTypeMesure;
  final montantCtl = TextEditingController(text: "0");
  File? pagneImageFile;
  File? modeleImageFile;
  final remiseCtl = TextEditingController(text: "0");
  final typeMesureApi = TypeMesureApi();
  final descriptionCtl = TextEditingController();
  bool hasImagePagne = false;
  final autreImagesMesure = <AutreImageMesureDto>[];
  final autreImagesPageCtl = PageController();
  int currentAutreImageIndex = 0;
  final tailleStandardApi = TailleStandardApi();
  TailleStandard? selectedTailleStandard;
  bool isSurMesure = true;
  
  List<MensurationDto> mensurations = [];

  // Variables pour la voix
  final SpeechRecognitionService _speech = SpeechRecognitionService();
  bool isListening = false;
  bool isProcessingSpeech = false;
  bool speechAvailable = false;
  String speechStatus = "";
  String recognizedText = "";
  final GeminiMesureService geminiService = GeminiMesureService();

  EditionPieceCouturePageVctl(this.ligne) {
    if (ligne != null) {
      nomTenancierCtl.text = ligne!.nomClient.value;
      montantCtl.setDouble = ligne!.montant;
      remiseCtl.setDouble = ligne!.remise;
      selectedTypeMesure = ligne!.typeMesureDto?.toModel();
      pagneImageFile =
          ligne!.pagneImagePath != null ? File(ligne!.pagneImagePath!) : null;
      modeleImageFile =
          ligne!.modeleImagePath != null ? File(ligne!.modeleImagePath!) : null;
      autreImagesMesure.addAll(ligne!.autresImages);
      isSurMesure = ligne!.tailleStandard == null;
      selectedTailleStandard = ligne!.tailleStandard;
      
      if (ligne!.typeMesureDto != null) {
        mensurations = ligne!.typeMesureDto!.mensurations.map((e) => e.clone()).toList();
        mensurations.sort((a, b) => a.categorieMesure.ordre.compareTo(b.categorieMesure.ordre));
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    _checkAndInitSpeech();
    _resolveVoiceTypeMesureIfNeeded();
  }

  /// Quand la pièce entière a été dictée (voir [GeminiMesureSheet]), Gemini
  /// ne connaît pas les types de pièce réels de l'entreprise : il renvoie un
  /// type "fictif" (id 0) accompagné des seules mensurations qu'il a pu
  /// comprendre dans la phrase. Une fois le vrai référentiel chargé (cache
  /// quasi instantané), on retrouve le type correspondant par libellé et on
  /// recompose la liste complète de ses mensurations, en y reportant les
  /// valeurs déjà extraites — le reste restant à saisir manuellement.
  Future<void> _resolveVoiceTypeMesureIfNeeded() async {
    final dto = ligne?.typeMesureDto;
    if (dto == null || dto.id != 0) return;

    final extracted = dto.mensurations;
    final guess = _normalizeLabel(dto.libelle);
    if (guess.isEmpty) return;

    final types = await fetchTypeMesures();
    TypeMesure? match;
    for (final t in types) {
      final lib = _normalizeLabel(t.libelle);
      if (lib.isEmpty) continue;
      if (lib == guess || lib.contains(guess) || guess.contains(lib)) {
        match = t;
        break;
      }
    }

    if (match != null) {
      selectedTypeMesure = match;
      mensurations =
          match.categories.map((c) => MensurationDto(categorieMesure: c)).toList();
      mensurations.sort((a, b) => a.categorieMesure.ordre.compareTo(b.categorieMesure.ordre));
      updateMensurations(extracted);
    }
    update();
  }

  Future<void> _checkAndInitSpeech() async {
    speechAvailable = await _speech.ensureReady(
      onStatus: (val) {
        speechStatus = val;
        if (val == 'done' || val == 'notListening') {
          isListening = false;
          update();
          if (recognizedText.isNotEmpty && !isProcessingSpeech) {
            _processSpeech(recognizedText);
          }
        } else {
          update();
        }
      },
      onError: (errorMsg) {
        isListening = false;
        if (errorMsg == 'error_speech_timeout' && recognizedText.isEmpty) {
          speechStatus = "Aucune voix détectée.";
        } else {
          speechStatus = "Info micro : $errorMsg";
        }
        update();
      },
    );
    update();
  }

  Future<void> toggleListening() async {
    if (selectedTypeMesure == null) {
      CMessageDialog.show(message: "Veuillez d'abord sélectionner un type de pièce.");
      return;
    }
    if (!speechAvailable) {
      await _checkAndInitSpeech();
    }

    if (isListening) {
      await _speech.stop();
      isListening = false;
      update();
    } else {
      if (speechAvailable) {
        isListening = true;
        speechStatus = "Écoute en cours...";
        recognizedText = "";
        update();

        await _speech.listen(
          onResult: (text) {
            recognizedText = text;
            speechStatus = "Texte capté !";
            update();
          },
        );
      } else {
        CMessageDialog.show(message: "Veuillez autoriser le micro.");
      }
    }
  }

  Future<void> _processSpeech(String text) async {
    isProcessingSpeech = true;
    update();
    try {
      final ligneMesure = await geminiService.extractMesureFromText(
        "${selectedTypeMesure?.libelle.value ?? 'Vêtement'} : $text",
        expectedCategories: mensurations.map((e) => e.categorieMesure.libelle ?? '').toList(),
      );
      if (ligneMesure != null && ligneMesure.typeMesureDto != null) {
        updateMensurations(ligneMesure.typeMesureDto!.mensurations);
      } else {
        CMessageDialog.show(message: "Aucune mesure n'a pu être extraite.");
      }
    } catch (e) {
      CMessageDialog.show(message: "Erreur lors de l'extraction des mesures.");
    } finally {
      isProcessingSpeech = false;
      recognizedText = "";
      update();
    }
  }

  void onTypeMesureChanged(TypeMesure? e) {
    selectedTypeMesure = e;
    if (e != null) {
       if (ligne?.typeMesureDto?.id == e.id) {
          mensurations = ligne!.typeMesureDto!.mensurations.map((m)=>m.clone()).toList();
       } else {
          mensurations = e.categories.map((c) => MensurationDto(categorieMesure: c)).toList();
       }
       mensurations.sort((a, b) => a.categorieMesure.ordre.compareTo(b.categorieMesure.ordre));
    } else {
       mensurations = [];
    }
    update();
  }
  
  /// Minuscules + accents retirés : Gemini renvoie parfois "Épaule" quand la
  /// catégorie est enregistrée "Epaule" (ou l'inverse), et une comparaison
  /// insensible à la casse seule laisse passer ce genre d'écart.
  static const _accents = 'àâäáãåèéêëìíîïòóôöõùúûüçñ';
  static const _noAccents = 'aaaaaaeeeeiiiiooooouuuucn';

  String _normalizeLabel(String? value) {
    var result = (value ?? '').toLowerCase().trim();
    for (var i = 0; i < _accents.length; i++) {
      result = result.replaceAll(_accents[i], _noAccents[i]);
    }
    return result;
  }

  void updateMensurations(List<MensurationDto> extracted) {
    for (var m in mensurations) {
      final key = _normalizeLabel(m.categorieMesure.libelle);
      for (var ext in extracted) {
        final extKey = _normalizeLabel(ext.categorieMesure.libelle);
        if (key.isNotEmpty && (extKey.contains(key) || key.contains(extKey))) {
          m.valeur = ext.valeur;
          m.isActive = true;
          break;
        }
      }
    }
    update();
  }

  Future<void> openReprendreMesuresClient() async {
    final result = await Get.to(() => const ReprendreMesuresClientPage());
    if (result is LigneMesureDto && result.typeMesureDto != null) {
      _applyHistoricalPiece(result);
    }
  }

  /// Reporte le type de pièce et toutes les mensurations d'une ancienne
  /// commande du client sur la pièce en cours de création, pour éviter de
  /// tout ressaisir quand il recommande un modèle déjà cousu.
  void _applyHistoricalPiece(LigneMesureDto dto) {
    selectedTypeMesure = dto.typeMesureDto!.toModel();
    mensurations = dto.typeMesureDto!.mensurations.map((m) => m.clone()).toList();
    mensurations.sort((a, b) => a.categorieMesure.ordre.compareTo(b.categorieMesure.ordre));
    selectedTailleStandard = dto.tailleStandard;
    isSurMesure = dto.tailleStandard == null;
    update();
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      ligne ??= LigneMesureDto();

      if (ligne!.typeMesureDto == null) {
        ligne!.typeMesureDto = TypeMesureDto.fromModel(selectedTypeMesure!);
      } else {
        ligne!.typeMesureDto!.model = selectedTypeMesure!;
      }
      ligne!.typeMesureDto!.mensurations = mensurations;
      ligne!.nomClient = nomTenancierCtl.text;
      ligne!.montant = montantCtl.toDouble();
      ligne!.remise = remiseCtl.toDouble();
      ligne!.pagneImagePath = pagneImageFile?.path;
      ligne!.modeleImagePath = modeleImageFile?.path;
      ligne!.withOutTissu = !hasImagePagne;
      ligne!.autresImages = [];
      ligne!.autresImages.addAll(autreImagesMesure);
      ligne!.tailleStandard = selectedTailleStandard;

      Get.back(result: ligne!);
    }
  }

  @override
  void onClose() {
    _speech.stop();
    autreImagesPageCtl.dispose();
    super.onClose();
  }

  // Ces deux listes changent rarement (référentiel de l'entreprise) : on
  // répond instantanément depuis le cache quand il existe, au lieu de faire
  // attendre l'utilisateur sur un aller-retour réseau à chaque pièce créée.

  Future<List<TypeMesure>> fetchTypeMesures() async {
    final cached = await typeMesureApi.readCachedList();
    if (cached != null && cached.isNotEmpty) {
      return cached.items.where((e) => e.categories.isNotEmpty).toList();
    }
    final res = await typeMesureApi.list(useCache: true);
    if (res.status) {
      return res.data!.items.where((e) => e.categories.isNotEmpty).toList();
    }
    return [];
  }

  Future<List<TailleStandard>> fetchTailleStandards() async {
    final cached = await tailleStandardApi.readCachedList();
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    final res = await tailleStandardApi.list();
    if (res.status) {
      return res.data!;
    }
    return [];
  }
}
