import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/modele_boutique.dart';

class ModeleBoutiqueApi extends CrudWebController<ModeleBoutique> {
  ModeleBoutiqueApi() : super(listApi: "/entreprise");

  @override
  ModeleBoutique get item => ModeleBoutique();

  @override
  String get module => "modeleBoutique";
}
