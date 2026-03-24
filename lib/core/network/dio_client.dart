import 'package:dio/dio.dart';
import '../prefs/prefs_helper.dart';

class DioClient {
  static final DioClient instance = DioClient._init();
  late final Dio _dio;

  DioClient._init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.ejemplo.com', // Cambiar por tu URL base
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Obtener el token de PrefsHelper
          final token = await PrefsHelper.instance.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Manejo global de errores si se requiere
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
