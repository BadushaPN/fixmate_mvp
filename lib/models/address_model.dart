class AddressModel {
  final String id;
  final String label;
  final String addressLine;
  final bool isCurrentLocation;
  final String? receiverName;
  final String? receiverPhone;

  AddressModel({
    required this.id,
    required this.label,
    required this.addressLine,
    this.isCurrentLocation = false,
    this.receiverName,
    this.receiverPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'addressLine': addressLine,
      'isCurrentLocation': isCurrentLocation,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      addressLine: json['addressLine'] ?? '',
      isCurrentLocation: json['isCurrentLocation'] ?? false,
      receiverName: json['receiverName'],
      receiverPhone: json['receiverPhone'],
    );
  }
}
