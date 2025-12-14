import 'package:ateliya/api/abstract/crud_web_controller.dart';
import 'package:ateliya/data/models/reservation.dart';

class ReservationApi extends CrudWebController<Reservation> {
  @override
  Reservation get item => Reservation();

  @override
  String get module => "reservation";
}
