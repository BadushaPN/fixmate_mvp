class BookingModel {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final DateTime date;
  final String timeSlot;
  final String status; // pending, confirmed, completed, cancelled
  final double price;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.price,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      userId: json['userId'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      date: DateTime.parse(json['date']),
      timeSlot: json['timeSlot'],
      status: json['status'],
      price: json['price'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
