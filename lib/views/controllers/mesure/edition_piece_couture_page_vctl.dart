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
import 'package:ateliya/tools/utils/label_matcher.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:ateliya/views/controllers/abstract/auth_view_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  bool speechAvailable = false;
  String speechStatus = "";
  String recognizedText = "";

  // Rang de la première mensuration que la dictée en cours doit remplir.
  //
  // Relancer le micro repart d'un texte vierge : sans ce repère, les nombres
  // du nouvel énoncé étaient réaffectés à partir du tout premier champ et
  // écrasaient les mesures déjà prises. On reprend donc à la première
  // mensuration encore vide.
  int _dictationAnchor = 0;

  /// Valeurs contenues dans la dernière transcription reçue.
  ///
  /// Une nouvelle liste qui diverge de celle-ci — ni prolongement, ni
  /// correction — signifie que le moteur est reparti de zéro : c'est le signal
  /// pour réancrer la dictée au lieu de réécrire, depuis le haut, des mesures
  /// déjà prises.
  List<String> _lastNumbers = [];

  /// Vrai si [a] est un début de [b] : le cas normal d'une transcription qui
  /// s'allonge au fil de la dictée.
  bool _estDebutDe(List<String> a, List<String> b) {
    if (a.length > b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Mensuration que la prochaine valeur dictée viendra remplir, affichée
  /// pendant l'écoute pour que le couturier sache toujours où il en est.
  String get prochaineMensuration {
    final actives = mensurations.where((m) => m.isActive).toList();
    final idx = _dictationAnchor + _lastNumbers.length;
    if (idx < 0 || idx >= actives.length) return "";
    return actives[idx].categorieMesure.libelle ?? "";
  }

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
    if (motsSignificatifs(dto.libelle).isEmpty) return;

    final types = await fetchTypeMesures();
    TypeMesure? match;
    var meilleurScore = 0.0;
    for (final t in types) {
      final score = similariteLibelle(dto.libelle, t.libelle);
      if (score > meilleurScore) {
        meilleurScore = score;
        match = t;
      }
    }
    if (meilleurScore < seuilCorrespondanceLibelle) match = null;

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
        if (val == 'done' || val == 'notListening') {
          if (!isListening) return; // déjà traité
          isListening = false;
          speechStatus = _allMensurationsFilled
              ? "Toutes les mensurations sont renseignées."
              : "Dictée interrompue — appuyez sur Dicter pour continuer.";
        } else {
          speechStatus = val;
        }
        update();
      },
      onError: (errorMsg) {
        isListening = false;
        if (errorMsg == 'error_speech_timeout' || errorMsg == 'error_no_match') {
          speechStatus = recognizedText.isEmpty
              ? "Aucune voix détectée."
              : (_allMensurationsFilled
                  ? "Toutes les mensurations sont renseignées."
                  : "Dictée interrompue — appuyez sur Dicter pour continuer.");
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
    if (mensurations.where((m) => m.isActive).isEmpty) {
      CMessageDialog.show(message: "Activez au moins une mensuration à renseigner.");
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
        // La dictée reprend à la première mensuration encore vide, pour qu'une
        // relance complète la série au lieu de réécrire les valeurs déjà prises.
        final actives = mensurations.where((m) => m.isActive).toList();
        final firstEmpty =
            actives.indexWhere((m) => m.valeur.isEmpty || m.valeur == '0');
        _dictationAnchor = firstEmpty < 0 ? 0 : firstEmpty;
        _lastNumbers = [];
        recognizedText = "";
        update();

        await _speech.listen(
          // Lire plusieurs mensurations à la suite implique de courtes
          // pauses naturelles entre chaque valeur (le temps de vérifier le
          // ruban), et Android éteint son moteur à chaque énoncé reconnu :
          // sans le mode continu, la dictée s'arrêtait d'elle-même au bout de
          // deux ou trois valeurs.
          continuous: true,
          // Prendre une mesure entre deux valeurs demande du temps : le moteur
          // doit tolérer ces silences sans clore la phrase, sous peine de
          // repartir pour une à trois secondes de réveil à chaque pause.
          pauseFor: const Duration(seconds: 30),
          // Court sans risque : la relance n'a lieu que si une voix est captée
          // sans être transcrite. Un silence pendant la prise de mesure, lui,
          // laisse la session intacte.
          stuckAfter: const Duration(seconds: 10),
          onResult: (text) {
            // Le moteur émet encore quelques résultats après l'arrêt : les
            // prendre en compte recollait le texte une seconde fois et la série
            // repartait du premier champ.
            if (!isListening) return;
            // Aucun recollage ici : le service accumule déjà l'intégralité de la
            // dictée en cours.
            recognizedText = text;
            speechStatus = "Texte capté !";
            // Remplissage en direct, au fil de la dictée : on dicte les
            // valeurs dans l'ordre d'affichage ("70 75 20 30...") plutôt que
            // de devoir nommer chaque mensuration — ce que la reconnaissance
            // vocale comprenait mal ("Dos" entendu "De", etc.).
            final allFilled = _assignNumbersInOrder(recognizedText);
            update();
            // Dès que tous les champs actifs ont leur valeur, on coupe
            // nous-mêmes le micro : laissé ouvert plus longtemps, le moteur
            // se mettait à boucler/répéter ce qu'il avait déjà entendu et
            // réécrivait les champs depuis le début avec ce bruit.
            if (allFilled && isListening) {
              _speech.stop();
              isListening = false;
              speechStatus = "Toutes les mensurations sont renseignées.";
              update();
            }
          },
        );
      } else {
        CMessageDialog.show(message: "Veuillez autoriser le micro.");
      }
    }
  }

  bool get _allMensurationsFilled {
    final actives = mensurations.where((m) => m.isActive).toList();
    return actives.isNotEmpty && actives.every((m) => m.valeur.isNotEmpty && m.valeur != '0');
  }

  /// Extrait les nombres de la dictée et les assigne, dans l'ordre, aux
  /// mensurations actives selon leur ordre d'affichage — aucune
  /// correspondance de mot nécessaire. Renvoie vrai si toutes les
  /// mensurations actives ont désormais une valeur.
  bool _assignNumbersInOrder(String text) {
    final numbers = RegExp(r'\d+(?:[.,]\d+)?')
        .allMatches(text)
        .map((m) => m.group(0)!.replaceAll(',', '.'))
        .toList();
    final actives = mensurations.where((m) => m.isActive).toList();

    // Garde-fou : une transcription plus courte que la précédente veut dire que
    // le moteur a recommencé son texte à zéro. Sans réancrage, les nouvelles
    // valeurs se réécrivaient par-dessus les premières mensurations, déjà
    // mesurées — le « il reprend en haut » constaté sur le terrain. On repart
    // donc de la première mensuration encore vide.
    final memeSerie = _estDebutDe(_lastNumbers, numbers) ||
        _estDebutDe(numbers, _lastNumbers);
    if (!memeSerie) {
      final libre = actives.indexWhere((m) => m.valeur.isEmpty || m.valeur == '0');
      _dictationAnchor = libre < 0 ? actives.length : libre;
      if (kDebugMode) debugPrint('STT/ transcription repartie de zéro -> réancrage sur $_dictationAnchor');
    }
    _lastNumbers = numbers;

    for (var i = 0; i < numbers.length; i++) {
      final cible = _dictationAnchor + i;
      if (cible >= actives.length) break;
      actives[cible].valeur = numbers[i];
    }
    if (kDebugMode) {
      debugPrint('STT/ dictée="$text" nombres=$numbers repère=$_dictationAnchor '
          'champs=${actives.length} '
          'valeurs=${actives.map((m) => m.valeur).toList()}');
    }
    return actives.isNotEmpty &&
        _dictationAnchor + numbers.length >= actives.length;
  }

  /// Repart d'une dictée vide (ex: après une erreur) sans toucher aux
  /// valeurs déjà renseignées manuellement.
  void clearDictation() {
    recognizedText = "";
    _dictationAnchor = 0;
    _lastNumbers = [];
    speechStatus = "";
    update();
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
  
  void updateMensurations(List<MensurationDto> extracted) {
    // Chaque mensuration prend la valeur dictée qui lui ressemble le plus, et
    // cette valeur n'est plus réutilisable ensuite : sans cela, un libellé
    // approximatif pouvait se poser sur plusieurs champs à la fois.
    final disponibles = [...extracted];
    for (final m in mensurations) {
      MensurationDto? meilleure;
      var meilleurScore = 0.0;
      for (final ext in disponibles) {
        final score = similariteLibelle(
          m.categorieMesure.libelle,
          ext.categorieMesure.libelle,
        );
        if (score > meilleurScore) {
          meilleurScore = score;
          meilleure = ext;
        }
      }
      if (meilleure != null && meilleurScore >= seuilCorrespondanceLibelle) {
        m.valeur = meilleure.valeur;
        m.isActive = true;
        disponibles.remove(meilleure);
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
