import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageConfig {
  static FlutterSecureStorage get instance {
    const AndroidOptions androidOptions = AndroidOptions();

    const IOSOptions iosOptions = IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    );

    return const FlutterSecureStorage(
      aOptions: androidOptions,
      iOptions: iosOptions,
    );
  }
}
