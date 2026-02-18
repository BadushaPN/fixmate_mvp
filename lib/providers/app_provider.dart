import '../services/storage_service.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  UserModel? _currentUser;
  List<BookingModel> _bookings = [];
  List<ServiceModel> _services = [];
  bool _isLoading = false;
  ThemeMode _themeMode = ThemeMode.system;

  UserModel? get currentUser => _currentUser;
  List<BookingModel> get bookings => _bookings;
  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    _setLoading(true);
    _currentUser = await _storage.getCurrentUser();
    if (_currentUser != null) {
      await fetchBookings();
    }
    _services = await _storage.getServices(); // Get mock services
    final mode = await _storage.getThemeMode();
    _themeMode = _parseThemeMode(mode);
    _setLoading(false);
  }

  Future<bool> login(String phoneNumber) async {
    _setLoading(true);
    try {
      _currentUser = await _storage.login(phoneNumber);
      await fetchBookings();
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.logout();
    _currentUser = null;
    _bookings = [];
    notifyListeners();
  }

  Future<void> fetchBookings() async {
    if (_currentUser == null) return;
    _bookings = await _storage.getUserBookings(_currentUser!.id);
    notifyListeners();
  }

  Future<void> createBooking({
    required ServiceModel service,
    required DateTime date,
    required String timeSlot,
    required double price,
  }) async {
    if (_currentUser == null) return;

    final booking = BookingModel(
      id: const Uuid().v4(),
      userId: _currentUser!.id,
      serviceId: service.id,
      serviceName: service.name,
      date: date,
      timeSlot: timeSlot,
      status: 'pending',
      price: price,
      createdAt: DateTime.now(),
    );

    await _storage.createBooking(booking);
    _bookings.insert(0, booking); // Add to local list immediately
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storage.saveThemeMode(_themeModeToString(mode));
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
