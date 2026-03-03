import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final isLoading = true.obs;
  final address = ''.obs;
  final error = ''.obs;

  double? latitude;
  double? longitude;

  String? _userId;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    await _loadUserId();
    await fetchAndSaveLocation();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userid');
  }

  Future<void> fetchAndSaveLocation() async {
    try {
      isLoading.value = true;
      error.value = '';

      final permissionGranted = await _ensurePermission();
      if (!permissionGranted) {
        throw 'Location permission denied';
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      final resolvedAddress = await _resolveAddress(latitude!, longitude!);

      address.value = resolvedAddress;

      await _updateLocationInFirestore(resolvedAddress, latitude!, longitude!);
    } catch (e) {
      error.value = 'Unable to fetch location';
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- HELPERS ----------------

  Future<bool> _ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<String> _resolveAddress(double lat, double lng) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isEmpty) return 'Unknown location';

    final p = placemarks.first;

    final parts = [
      p.street,
      p.subLocality,
      p.locality,
      p.administrativeArea,
    ].where((e) => e != null && e!.isNotEmpty).toList();

    return parts.join(', ');
  }

  Future<void> _updateLocationInFirestore(
    String address,
    double lat,
    double lng,
  ) async {
    if (_userId == null) return;

    await FirebaseFirestore.instance.collection('customers').doc(_userId).set({
      'useraddress': address,
      'location': {'lat': lat, 'lng': lng},
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
