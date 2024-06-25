import 'package:dio/dio.dart';
import 'package:siptatif_mobile/configs/dio_client.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';

class PembimbingService {
  final _dio = DioClient.instance;

  Future<Response<dynamic>> getAllPembimbing() async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');

    // Menambahkan header Authorization ke dalam permintaan
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.get("/pembimbing", options: options);
  }

  Future<Response<dynamic>> createPembimbing(Map<String, dynamic> data) async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');

    // Menambahkan header Authorization ke dalam permintaan
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.post(
      "/pembimbing",
      data: data,
      options: options,
    );
  }

  Future<Response<dynamic>> updatePembimbing(
      Map<String, dynamic> data, nidn) async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');

    // Menambahkan header Authorization ke dalam permintaan
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.put(
      "/pembimbing/$nidn",
      data: data,
      options: options,
    );
  }

  Future<Response<dynamic>> deletePembimbing(nidn) async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.delete(
      "/pembimbing/$nidn",
      options: options,
    );
  }

  Future<Response<dynamic>> searchDataPembimbing( {final search = ''}) async {
    String? accessToken = await SecureStorage().readSecureData('accessToken');
    Options options = Options(headers: {
      'Authorization': 'Bearer $accessToken',
    });
    return await _dio.get(
      "/pembimbing?search=$search",
      options: options
    );
  }

    
  }

