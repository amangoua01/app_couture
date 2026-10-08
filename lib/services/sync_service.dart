import 'dart:async';
import 'dart:convert';

import 'package:ateliya/data/local/local_db.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/tools/components/custom_http_client.dart';
import 'package:ateliya/tools/components/session_manager_view_controller.dart';
import 'package:ateliya/tools/constants/env.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

/// File d'attente locale pour les créations/modifications de client ou de
/// facture faites sans réseau : l'opération est enregistrée dans SQLite
/// et rejouée automatiquement dès que la connexion revient, plutôt que de
/// simplement échouer. `ClientApi`/`FactureApi` ne passent par ici que
/// lorsque [isOffline] est vrai — en ligne, le comportement normal
/// (réseau immédiat) est inchangé.
class SyncService {
  final LocalDb _db = LocalDb();
  final _uuid = const Uuid();
  bool _isSyncing = false;

  static Future<bool> isOffline() async {
    final results = await Connectivity().checkConnectivity();
    return results.every((r) => r == ConnectivityResult.none);
  }

  void initNetworkListener() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        syncAll();
      }
    });
  }

  /// [filePaths] : chemins locaux des fichiers joints (ex: photo client),
  /// réattachés à l'objet au moment du renvoi — jamais le fichier
  /// lui-même, qui ne serait pas sérialisable dans la file d'attente.
  Future<String> enqueueOperation(
    String entityType,
    String operation,
    Map<String, dynamic> payload, {
    Map<String, String>? filePaths,
  }) async {
    final uuid = _uuid.v4();
    final db = await _db.database;

    payload['uuid'] = uuid;

    await db.insert('sync_queue', {
      'uuid': uuid,
      'entity_type': entityType,
      'operation': operation,
      'payload': jsonEncode(payload),
      'files_payload': filePaths != null ? jsonEncode(filePaths) : null,
      'status': 'PENDING',
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Tente de synchroniser tout de suite en arrière-plan, au cas où le
    // réseau serait déjà revenu entre l'échec initial et cet appel.
    syncAll();
    return uuid;
  }

  Future<void> syncAll() async {
    if (_isSyncing) return;
    if (await isOffline()) return;
    _isSyncing = true;

    try {
      final db = await _db.database;
      final pending = await db.query(
        'sync_queue',
        where: "status = 'PENDING'",
        orderBy: 'id ASC',
      );

      for (var task in pending) {
        final uuid = task['uuid'] as String;
        final entityType = task['entity_type'] as String;
        final payload =
            jsonDecode(task['payload'] as String) as Map<String, dynamic>;
        final filesRaw = task['files_payload'] as String?;
        final filePaths =
            filesRaw != null
                ? Map<String, String>.from(jsonDecode(filesRaw) as Map)
                : null;

        final success = await _pushToServer(entityType, payload, filePaths);

        if (success) {
          await db.update(
            'sync_queue',
            {'status': 'SYNCED'},
            where: 'uuid = ?',
            whereArgs: [uuid],
          );
        }
      }
      await _db.clearQueue();
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _pushToServer(
    String entityType,
    Map<String, dynamic> payload,
    Map<String, String>? filePaths,
  ) async {
    try {
      final httpClient = CustomHttpClient();
      final hasId = payload['id'] != null && payload['id'] != 0;
      final headers = {
        "Authorization": "Bearer ${SessionManagerViewController.jwt}",
      };

      late final int statusCode;

      if (entityType == 'client') {
        final item = Client.fromJson(payload);
        final photoPath = filePaths?['photo'];
        if (photoPath != null && photoPath.isNotEmpty) {
          item.photo = FichierLocal(path: photoPath);
        }
        final endpoint =
            hasId
                ? "${Env.baseUrl.url}/api/client/update/${payload['id']}"
                : "${Env.baseUrl.url}/api/client/create";
        final response = await httpClient.multiPart(
          Uri.parse(endpoint),
          body: item.toFields(),
          files: await item.toMultipartFile(),
          headers: headers,
        );
        statusCode = response.statusCode;
      } else {
        // Seul 'client' est actuellement mis en file : le modèle Facture
        // n'implémente pas encore toJson()/fromJson() (le vrai flux de
        // création de facture passe par MesureApi, pas FactureApi), donc
        // rien ne met jamais de tâche 'facture' en attente pour l'instant.
        if (kDebugMode) {
          debugPrint(
            "Sync: type d'entité non pris en charge : $entityType",
          );
        }
        return false;
      }

      if (kDebugMode) {
        debugPrint("Sync of $entityType returned: $statusCode");
      }
      return statusCode == 200 || statusCode == 201;
    } catch (e) {
      if (kDebugMode) debugPrint("Erreur de synchronisation pour $entityType: $e");
      return false;
    }
  }
}
