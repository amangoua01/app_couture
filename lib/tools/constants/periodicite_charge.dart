/// Fréquence à laquelle une [Charge] revient, purement informative : sert à
/// pré-remplir la dépense au bon rythme, sans rappel automatique.
enum PeriodiciteCharge {
  mensuelle("mensuelle", "Mensuelle"),
  trimestrielle("trimestrielle", "Trimestrielle"),
  semestrielle("semestrielle", "Semestrielle"),
  annuelle("annuelle", "Annuelle");

  final String code;
  final String label;

  const PeriodiciteCharge(this.code, this.label);

  static PeriodiciteCharge? fromCode(String? code) {
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }
}
