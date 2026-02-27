import 'package:get_it/get_it.dart';

// Standar penamaan untuk GetIt biasanya adalah 'sl' (Service Locator)
final sl = GetIt.instance;

Future<void> init() async {
  // ===============================================================
  // Nanti kita akan mendaftarkan semua dependensi di sini.
  // Urutan yang baik: Core -> Data Sources -> Repositories -> UseCases -> BLoC
  // ===============================================================

  // Contoh (Jangan di-uncomment dulu karena file-nya belum ada):
  // sl.registerLazySingleton<Dio>(() => Dio());
}
