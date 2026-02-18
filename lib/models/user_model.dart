class UserModel {
  final String id;
  final String phoneNumber;
  final String name;

  UserModel({required this.id, required this.phoneNumber, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'phoneNumber': phoneNumber, 'name': name};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
    );
  }
}
