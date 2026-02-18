import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _bookingsKey = 'bookings';
  static const String _userKey = 'current_user';
  static const String _themeModeKey = 'theme_mode';

  // Mock Data
  final List<ServiceModel> _services = [
    ServiceModel(id: '1', name: 'Electrician', iconCode: 'e0b5'), // power
    ServiceModel(id: '2', name: 'Plumber', iconCode: 'f10b'), // plumbing
    ServiceModel(id: '3', name: 'AC Repair', iconCode: 'eb3b'), // ac_unit
    ServiceModel(
      id: '4',
      name: 'Cleaning',
      iconCode: 'e14f',
    ), // cleaning_services
    ServiceModel(id: '5', name: 'Painting', iconCode: 'e25e'), // format_paint
    ServiceModel(id: '6', name: 'RO Service', iconCode: 'e3bb'), // water_drop
  ];

  Future<List<ServiceModel>> getServices() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _services;
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookingsString = prefs.getString(_bookingsKey);
    if (bookingsString == null) return [];

    final List<dynamic> decoded = jsonDecode(bookingsString);
    final bookings = decoded
        .map((e) => BookingModel.fromJson(e))
        .where((b) => b.userId == userId)
        .toList();

    // Sort by date descending
    bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return bookings;
  }

  Future<void> createBooking(BookingModel booking) async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookingsString = prefs.getString(_bookingsKey);
    List<dynamic> bookingsList = [];

    if (bookingsString != null) {
      bookingsList = jsonDecode(bookingsString);
    }

    bookingsList.add(booking.toJson());
    await prefs.setString(_bookingsKey, jsonEncode(bookingsList));
  }

  // Mock Auth
  Future<UserModel> login(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simple mock: any phone number works
    final user = UserModel(
      id: phoneNumber, // Use phone as ID for simplicity
      phoneNumber: phoneNumber,
      name: 'User ${phoneNumber.substring(phoneNumber.length - 4)}',
    );
    await _saveUser(user);
    return user;
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString(_userKey);
    if (userString == null) return null;
    return UserModel.fromJson(jsonDecode(userString));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }
}
