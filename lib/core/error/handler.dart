import 'package:dio/dio.dart';
import 'exceptions.dart';

class ErrorHandler {
  static ServerException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message:
              'Koneksi terlalu lama. Server mungkin sedang sibuk atau sinyal Anda kurang stabil.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        String errorMessage = 'Terjadi kesalahan pada sistem.';
        if (responseData != null &&
            responseData is Map<String, dynamic> &&
            responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }

        if (statusCode == 400) {
          return ServerException(message: errorMessage, statusCode: statusCode);
        } else if (statusCode == 401) {
          return ServerException(
            message: 'Sesi Anda telah berakhir. Silakan masuk kembali.',
            statusCode: statusCode,
          );
        } else if (statusCode == 403) {
          return ServerException(
            message: 'Anda tidak memiliki izin untuk mengakses halaman ini.',
            statusCode: statusCode,
          );
        } else if (statusCode == 404) {
          return ServerException(
            message: 'Data yang Anda cari tidak ditemukan.',
            statusCode: statusCode,
          );
        } else if (statusCode! >= 500) {
          return ServerException(
            message:
                'Server sedang dalam perbaikan. Mohon coba beberapa saat lagi.',
            statusCode: statusCode,
          );
        }
        return ServerException(message: errorMessage, statusCode: statusCode);

      case DioExceptionType.cancel:
        return ServerException(message: 'Permintaan ke server dibatalkan.');

      case DioExceptionType.connectionError:
        return ServerException(
          message:
              'Tidak dapat terhubung ke server. Pastikan Anda memiliki koneksi internet.',
        );

      case DioExceptionType.unknown:
      default:
        return ServerException(
          message:
              'Terjadi kesalahan yang tidak terduga. Mohon coba lagi nanti.',
        );
    }
  }
}
