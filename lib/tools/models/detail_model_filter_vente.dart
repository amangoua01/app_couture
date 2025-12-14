import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';

class DetailModelFilterVente {
  DateTimeEditingController dateDebut = DateTimeEditingController();
  DateTimeEditingController dateFin = DateTimeEditingController();
  Client? client;

  bool isEmpty() {
    return dateDebut.textController.text.isEmpty &&
        dateFin.textController.text.isEmpty &&
        client == null;
  }
}
