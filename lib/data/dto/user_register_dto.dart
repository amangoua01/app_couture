import 'package:ateliya/data/dto/abstract/dto_model.dart';

class UserRegisterDto extends DtoModel {
  String email;
  String password;
  String confirmPassword;
  String denominationEntreprise;
  String emailEntreprise;
  String numeroEntreprise;
  int pays;

  UserRegisterDto(
      {required this.email,
      required this.password,
      required this.confirmPassword,
      required this.denominationEntreprise,
      required this.emailEntreprise,
      required this.numeroEntreprise,
      required this.pays});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['denominationEntreprise'] = denominationEntreprise;
    data['emailEntreprise'] = emailEntreprise;
    data['numeroEntreprise'] = numeroEntreprise;
    data['pays'] = pays;
    return data;
  }
}
