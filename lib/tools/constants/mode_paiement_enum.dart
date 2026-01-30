enum ModePaiementEnum {
  especes,
  orangeMoney,
  mtnMoney,
  moovMoney,
  wave,
  autre;

  String get label {
    switch (this) {
      case ModePaiementEnum.especes:
        return "Espèces";
      case ModePaiementEnum.orangeMoney:
        return "Orange Money";
      case ModePaiementEnum.mtnMoney:
        return "MTN Money";
      case ModePaiementEnum.moovMoney:
        return "Moov Money";
      case ModePaiementEnum.wave:
        return "Wave";
      case ModePaiementEnum.autre:
        return "Autre";
    }
  }

  static ModePaiementEnum fromLabel(String label) {
    return ModePaiementEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => ModePaiementEnum.autre,
    );
  }
}
