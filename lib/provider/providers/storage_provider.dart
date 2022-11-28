import 'package:fluttering/fluttering.dart';

abstract class IStorageProvider extends Provider with ProviderDelegate {}

class StorageProvider extends IStorageProvider {
  static final StorageProvider _instance = StorageProvider._internal();
  static StorageProvider get instance => _instance;

  factory StorageProvider() => _instance;

  StorageProvider._internal();

  void initial() {
    AsyncStorage.instance.addListener(_listenStorageChanged);
  }

  _listenStorageChanged(AsyncStorageEvent event) {
    notifyListeners();
  }

  @override
  Future<bool> registered() async {
    initial();
    return true;
  }
}
