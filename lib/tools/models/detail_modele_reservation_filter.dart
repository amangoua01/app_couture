import 'package:ateliya/data/models/client.dart';
import 'package:ateliya/tools/widgets/date_time_editing_controller.dart';

class DetailModeleReservationFilter {
  DateTimeEditingController dateDebut = DateTimeEditingController();
  DateTimeEditingController dateFin = DateTimeEditingController();
  Client? client;
  String? status; // en_attente, confirmee, annulee

  bool isEmpty() {
    return dateDebut.textController.text.isEmpty &&
        dateFin.textController.text.isEmpty &&
        client == null &&
        status == null;
  }

  void clear() {
    dateDebut.clear();
    dateFin.clear();
    client = null;
    status = null;
  }
}
