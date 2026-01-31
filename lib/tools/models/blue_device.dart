class BlueDevice {
  final String name;
  final String address;
  bool isConnected;
  final bool _isEmpty;

  BlueDevice(
      {required this.name, required this.address, this.isConnected = false})
      : _isEmpty = false;

  BlueDevice.empty()
      : name = "",
        address = "",
        isConnected = false,
        _isEmpty = true;

  BlueDevice.fromJson(dynamic json)
      : name = json["name"],
        address = json["address"],
        isConnected = json["isConnected"] ?? false,
        _isEmpty = false;

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "isConnected": isConnected,
      };

  bool get isEmpty => _isEmpty;
  bool get isNoEmpty => !_isEmpty;
}
