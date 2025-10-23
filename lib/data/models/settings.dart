class Settings {
  int? id;
  int? nombreUser;
  int? nombreSms;
  int? nombreSuccursale;
  int? nombreJourRestantPourEnvoyerSms;
  int? numeroAbonnement;
  Null createdAt;

  Settings(
      {this.id,
      this.nombreUser,
      this.nombreSms,
      this.nombreSuccursale,
      this.nombreJourRestantPourEnvoyerSms,
      this.numeroAbonnement,
      this.createdAt});

  Settings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombreUser = json['nombreUser'];
    nombreSms = json['nombreSms'];
    nombreSuccursale = json['nombreSuccursale'];
    nombreJourRestantPourEnvoyerSms = json['nombreJourRestantPourEnvoyerSms'];
    numeroAbonnement = json['numeroAbonnement'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nombreUser'] = nombreUser;
    data['nombreSms'] = nombreSms;
    data['nombreSuccursale'] = nombreSuccursale;
    data['nombreJourRestantPourEnvoyerSms'] = nombreJourRestantPourEnvoyerSms;
    data['numeroAbonnement'] = numeroAbonnement;
    data['createdAt'] = createdAt;
    return data;
  }
}
