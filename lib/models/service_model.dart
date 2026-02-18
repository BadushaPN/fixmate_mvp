class ServiceModel {
  final String id;
  final String name;
  final String
  iconCode; // Using string for icon code point since we can't easily ser/deser IconData

  ServiceModel({required this.id, required this.name, required this.iconCode});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'iconCode': iconCode};
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      iconCode: json['iconCode'],
    );
  }
}
