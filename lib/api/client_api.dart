import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/data/models/fichier_local.dart';
import 'package:ateliya/services/sync_service.dart';
import 'package:ateliya/tools/models/data_response.dart';

class ClientApi extends CrudWebController<Client> {
  @override
  Client get item => Client();

  @override
  String get module => "client";

  ClientApi() : super(listApi: 'entreprise');

  @override
  Future<DataResponse<Client>> create(Client item) async {
    if (await SyncService.isOffline()) return _queueOffline(item, 'create');
    return super.create(item);
  }

  @override
  Future<DataResponse<Client>> update(Client item) async {
    if (await SyncService.isOffline()) return _queueOffline(item, 'update');
    return super.update(item);
  }

  /// Enregistre le client localement et met l'opération en file d'attente
  /// — synchronisée automatiquement au retour du réseau (voir
  /// SyncService). L'objet retourné n'a pas encore d'id serveur réel tant
  /// que la synchro n'a pas eu lieu.
  Future<DataResponse<Client>> _queueOffline(
    Client item,
    String operation,
  ) async {
    final payload = item.toJson();
    Map<String, String>? filePaths;
    if (item.photo is FichierLocal) {
      filePaths = {'photo': (item.photo as FichierLocal).path};
    }

    final uuid = await SyncService().enqueueOperation(
      'client',
      operation,
      payload,
      filePaths: filePaths,
    );
    payload['uuid'] = uuid;
    final localItem = item.fromJson(payload);

    return DataResponse.success(
      data: localItem,
      message: "Enregistré hors-ligne : sera synchronisé au retour du réseau",
    );
  }
}
