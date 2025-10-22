import 'package:app_couture/api/abstract/crud_web_controller.dart';
import 'package:app_couture/data/models/boutique.dart';

class BoutiqueApi extends CrudWebController<Boutique> {
  @override
  Boutique get item => Boutique();

  @override
  String get module => "boutiques";
}
