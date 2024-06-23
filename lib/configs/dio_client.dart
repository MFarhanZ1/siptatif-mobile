import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      headers: {
        'Content-Type': 'application/json',
      },
      followRedirects: false,
      validateStatus: (status) {
        return status != null && status <= 500;
      },
    ),
  );

  static Dio get instance => _dio;
}
