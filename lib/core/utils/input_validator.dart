class InputValidator {
  /// Internal Helper: Check if value is empty (null or just spaces)
  static bool _isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  // ==========================================
  // INPUT VALIDATOR
  // ==========================================
  static String? required(
    String? value, {
    String? fieldName,
    String? errorMessage,
  }) {
    if (_isEmpty(value)) {
      return errorMessage ?? '${fieldName ?? 'Kolom ini'} wajib diisi';
    }
    return null;
  }

  static String? email(
    String? value, {
    String? errorMessage,
  }) {
    if (_isEmpty(value)) return null;

    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    if (!emailRegex.hasMatch(value!)) {
      return errorMessage ?? 'Format email tidak valid';
    }
    return null;
  }

  static String? password(
    String? value, {
    int minLength = 8,
    String? errorMessage,
  }) {
    if (_isEmpty(value)) return null;

    if (value!.length < minLength) {
      return errorMessage ?? 'Kata sandi minimal $minLength karakter';
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String originalPassword, {
    String? errorMessage,
  }) {
    if (_isEmpty(value)) return null;

    if (value != originalPassword) {
      return errorMessage ?? 'Kata sandi tidak cocok';
    }
    return null;
  }

  static String? phone(
    String? value, {
    String? errorMessage,
    int minLength = 9,
    int maxLength = 15,
  }) {
    if (_isEmpty(value)) return null;

    final RegExp phoneRegex = RegExp(
      r'^\\+?[0-9]{$minLength,$maxLength}\$',
    );

    if (!phoneRegex.hasMatch(value!)) {
      return errorMessage ??
          'Format nomor telepon tidak valid ($minLength-$maxLength digit)';
    }
    return null;
  }

  static String? name(
    String? value, {
    String? errorMessage,
    int minLength = 3,
    int maxLength = 100,
  }) {
    if (_isEmpty(value)) return null;

    if (value!.length < minLength || value.length > maxLength) {
      return errorMessage ??
          'Nama harus antara $minLength hingga $maxLength karakter';
    }

    final RegExp nameRegex = RegExp(
      r"^[a-zA-Z\s\.\-']+$",
    );
    if (!nameRegex.hasMatch(value)) {
      return errorMessage ?? 'Format nama tidak valid (hindari simbol khusus)';
    }

    return null;
  }

  static String? address(
    String? value, {
    String? errorMessage,
    int minLength = 5,
    int maxLength = 255,
  }) {
    if (_isEmpty(value)) return null;

    if (value!.length < minLength || value.length > maxLength) {
      return errorMessage ??
          'Alamat harus antara $minLength hingga $maxLength karakter';
    }

    final RegExp addressRegex = RegExp(
      r"^[a-zA-Z0-9\s\.,\-\/'#]+$",
    );
    if (!addressRegex.hasMatch(value)) {
      return errorMessage ?? 'Format alamat tidak valid';
    }

    return null;
  }

  static String? age(
    String? value, {
    String? errorMessage,
    int minAge = 18,
    int maxAge = 120,
  }) {
    if (_isEmpty(value)) return null;

    final RegExp ageRegex = RegExp(r'^[0-9]+$');
    if (!ageRegex.hasMatch(value!)) {
      return errorMessage ?? 'Umur harus berupa angka';
    }

    final int? age = int.tryParse(value);
    if (age == null || age < minAge || age > maxAge) {
      return errorMessage ?? 'Umur harus antara $minAge dan $maxAge tahun';
    }

    return null;
  }

  static String? gender(
    String? value, {
    String? errorMessage,
    List<String> allowedValues = const ['male', 'female'],
  }) {
    if (_isEmpty(value)) return null;

    if (!allowedValues.contains(value!.toLowerCase())) {
      return errorMessage ?? 'Pilihan jenis kelamin tidak valid';
    }

    return null;
  }

  static String? number(
    String? value, {
    String? errorMessage,
    int minNumber = 0,
    int maxNumber = 99999999999,
  }) {
    if (_isEmpty(value)) return null;

    final RegExp numberRegex = RegExp(r'^[0-9]+$');
    if (!numberRegex.hasMatch(value!)) {
      return errorMessage ?? 'Format nomor tidak valid';
    }

    final int? number = int.tryParse(value);
    if (number == null || number < minNumber || number > maxNumber) {
      return errorMessage ?? 'Nomor harus antara $minNumber dan $maxNumber';
    }

    return null;
  }
}
