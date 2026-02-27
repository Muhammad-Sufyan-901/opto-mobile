import 'package:hive_flutter/hive_flutter.dart';

class HiveClient {
  static Future<void> init() async {
    // 1. Inisialisasi Hive agar mengenali direktori penyimpanan di HP
    await Hive.initFlutter();

    // 2. Registrasi Adapter (Nanti kita isi saat sudah membuat model data)
    // Contoh: Hive.registerAdapter(LansiaProfileAdapter());

    // 3. Buka Box (Tabel) yang selalu dibutuhkan sejak awal
    // Contoh untuk menyimpan pengaturan tema atau status pertama kali buka aplikasi
    await Hive.openBox('settings_box');
  }
}
