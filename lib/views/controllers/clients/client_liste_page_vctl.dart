import 'package:ateliya/api/client_api.dart';
import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';

class ClientListePageVctl extends ListViewController<Client> {
  ClientListePageVctl() : super(ClientApi(), provideIdToListApi: false);
}
