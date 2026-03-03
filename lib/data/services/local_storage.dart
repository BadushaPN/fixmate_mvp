import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final _box = GetStorage();

  static void write(String key, dynamic value) {
    _box.write(key, value);
  }

  static T? read<T>(String key) {
    return _box.read<T>(key);
  }

  static void remove(String key) {
    _box.remove(key);
  }

  static void clear() {
    _box.erase();
  }
}
