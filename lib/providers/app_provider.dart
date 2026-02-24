import '../services/storage_service.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/address_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  UserModel? _currentUser;
  List<BookingModel> _bookings = [];
  List<ServiceModel> _services = [];
  List<AddressModel> _addresses = [];
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  List<BookingModel> get bookings => _bookings;
  List<ServiceModel> get services => _services;
  List<AddressModel> get addresses => _addresses;
  AddressModel? get currentLocationAddress {
    try {
      return _addresses.firstWhere((a) => a.isCurrentLocation);
    } catch (_) {
      return null;
    }
  }

  bool get isLoading => _isLoading;

  Future<void> init() async {
    _setLoading(true);
    _currentUser = await _storage.getCurrentUser();
    if (_currentUser != null) {
      await fetchBookings();
      await loadAddresses();
    }
    _services = await _storage.getServices(); // Get mock services
    _setLoading(false);
  }

  Future<bool> login(String phoneNumber) async {
    _setLoading(true);
    try {
      _currentUser = await _storage.login(phoneNumber);
      await fetchBookings();
      await loadAddresses();
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
    _addresses = [];
    notifyListeners();
  }

  Future<void> fetchBookings() async {
    if (_currentUser == null) return;
    _bookings = await _storage.getUserBookings(_currentUser!.id);
    notifyListeners();
  }

  Future<BookingModel?> createBooking({
    required ServiceModel service,
    required DateTime date,
    required String timeSlot,
    required double price,
    required String addressLine,
    String? receiverName,
    String? receiverPhone,
    List<String> imagePaths = const [],
  }) async {
    if (_currentUser == null) return null;

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
      addressLine: addressLine,
      receiverName: receiverName,
      receiverPhone: receiverPhone,
      imagePaths: imagePaths,
    );

    await _storage.createBooking(booking);
    _bookings.insert(0, booking); // Add to local list immediately
    notifyListeners();
    return booking;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadAddresses() async {
    if (_currentUser == null) return;
    _addresses = await _storage.getUserAddresses(_currentUser!.id);
    notifyListeners();
  }

  Future<void> saveAddress(AddressModel address) async {
    if (_currentUser == null) return;
    await _storage.saveUserAddress(_currentUser!.id, address);
    await loadAddresses();
  }

  Future<void> updateProfileName(String name) async {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      id: _currentUser!.id,
      phoneNumber: _currentUser!.phoneNumber,
      name: name,
    );
    await _storage.saveCurrentUser(_currentUser!);
    notifyListeners();
  }

  Future<void> setCurrentLocationAddress(String addressLine) async {
    if (_currentUser == null) return;
    final current = List<AddressModel>.from(_addresses);
    final filtered = current.where((a) => !a.isCurrentLocation).toList();
    filtered.insert(
      0,
      AddressModel(
        id: 'current_location',
        label: 'Current Location',
        addressLine: addressLine,
        isCurrentLocation: true,
      ),
    );
    _addresses = filtered;
    await _storage.saveAllUserAddresses(_currentUser!.id, filtered);
    notifyListeners();
  }

}
