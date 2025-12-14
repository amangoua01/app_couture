import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/client.dart';

class ClientApi extends CrudWebController<Client> {
  @override
  Client get item => Client();

  @override
  String get module => "client";

  ClientApi() : super(listApi: 'entreprise');
}
