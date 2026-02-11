import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/modele.dart';

class ModeleApi extends CrudWebController<Modele> {
  ModeleApi() : super(listApi: "/entreprise");

  @override
  Modele get item => Modele();

  @override
  String get module => "modele";
}
