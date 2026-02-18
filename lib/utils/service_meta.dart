import '../models/service_model.dart';

class ServiceMeta {
  static const Map<String, int> _startingPriceByName = {
    'Electrician': 399,
    'Plumber': 349,
    'AC Repair': 599,
    'Cleaning': 499,
    'Painting': 699,
    'RO Service': 449,
  };

  static const Map<String, String> _nextSlotByName = {
    'Electrician': 'Today, 4:30 PM',
    'Plumber': 'Today, 5:00 PM',
    'AC Repair': 'Tomorrow, 9:00 AM',
    'Cleaning': 'Today, 6:00 PM',
    'Painting': 'Tomorrow, 11:00 AM',
    'RO Service': 'Today, 7:00 PM',
  };

  static int startingPrice(ServiceModel service) {
    return _startingPriceByName[service.name] ?? 500;
  }

  static String nextAvailableSlot(ServiceModel service) {
    return _nextSlotByName[service.name] ?? 'Today, 5:30 PM';
  }
}
