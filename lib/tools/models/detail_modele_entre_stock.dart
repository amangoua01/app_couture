import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';

class DetailModeleEntreStock {
  DateTimeEditingController dateDebut = DateTimeEditingController();
  DateTimeEditingController dateFin = DateTimeEditingController();
  User? operateur;

  bool isEmpty() {
    return dateDebut.textController.text.isEmpty &&
        dateFin.textController.text.isEmpty &&
        operateur == null;
  }
}
