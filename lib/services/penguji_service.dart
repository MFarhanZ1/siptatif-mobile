import 'package:dio/dio.dart';
import 'package:siptatif_mobile/configs/dio_client.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';

class PengujiService {
  final _dio = DioClient.instance;

  Future<Response<dynamic>> createPenguji(Map<String, dynamic> data) async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');

    // Menambahkan header Authorization ke dalam permintaan
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.post(
      "/penguji",
      data: data,
      options: options,
    );
  }

  Future<Response<dynamic>> getAllPenguji() async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');
    // Menambahkan header Authorization ke dalam permintaan
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.get("/penguji", options: options);
  }
  
  Future<Response<dynamic>> updatePenguji(
      Map<String, dynamic> data, nidn) async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');

    // Menambahkan header Authorization ke dalam permintaan
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.put(
      "/penguji/$nidn",
      data: data,
      options: options,
    );
  }

  Future<Response<dynamic>> deletePenguji(nidn) async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.delete(
      "/penguji/$nidn",
      options: options,
    );
  }
  Future<Response<dynamic>> searchDataPenguji( {final search = ''}) async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.get(
      "/penguji?search=$search",
      options: options
    );
  }
}
