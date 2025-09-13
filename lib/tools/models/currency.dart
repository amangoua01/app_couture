class Currency {
  final String label, code;
  final int decimalDigits;

  const Currency(this.label, {this.code = "", this.decimalDigits = 0});

  @override
  String toString() => label;
}
