import 'package:dio/dio.dart';
import 'package:siptatif_mobile/configs/dio_client.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';

class DosenService {
  final _dio = DioClient.instance;

  Future<Response<dynamic>> getAllDosen() async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.get(
      "/dosen",
      options:options
    );
  }
}
