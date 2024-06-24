import 'package:dio/dio.dart';
import 'package:siptatif_mobile/configs/dio_client.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';

class PembimbingService {
  final _dio = DioClient.instance;

  Future<Response<dynamic>> getAllPenguji() async {
      String? accessToken = await SecureStorage().readSecureData('accessToken');

    // Menambahkan header Authorization ke dalam permintaan
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.get(
      "/pembimbing",
      options: options
    );
  }
}
