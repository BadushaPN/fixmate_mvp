enum RequestStatus { waiting, accepted, cancelled }

class RequestModel {
  final String id;
  final String description;
  final String imageUrl;
  final RequestStatus status;
  final DateTime createdAt;

  RequestModel({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'imageUrl': imageUrl,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      status: RequestStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
