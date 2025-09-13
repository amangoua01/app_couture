extension BoolExt on bool? {
  int toInt() => this == true ? 1 : 0;

  bool toBool(int value) => (value == 1) ? true : false;
}
