enum TypeUserEnum {
  none("NONE"),
  ads("ADS"),
  adsb("ADSB"),
  adb("ADB"),
  sadm("SADM");

  final String code;

  const TypeUserEnum(this.code);

  static TypeUserEnum fromCode(String? code) {
    for (var value in TypeUserEnum.values) {
      if (value.code == code) {
        return value;
      }
    }
    return TypeUserEnum.none;
  }

  bool get isAdmin => this == TypeUserEnum.sadm;
}
