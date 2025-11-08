import 'package:app_couture/api/client_api.dart';
import 'package:app_couture/data/models/client.dart';
import 'package:app_couture/views/controllers/abstract/list_view_controller.dart';

class ClientListePageVctl extends ListViewController<Client> {
  ClientListePageVctl() : super(ClientApi(), provideIdToListApi: false);
}
