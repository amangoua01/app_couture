import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/facture.dart';

class FactureApi extends CrudWebController<Facture> {
  @override
  Facture get item => Facture();

  @override
  String get module => "facture";
}
