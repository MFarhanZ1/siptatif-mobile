import 'package:dio/dio.dart';
import 'package:siptatif_mobile/configs/dio_client.dart';

class MahasiswaService {
  final _dio = DioClient.instance;

  Future<Response> getTugasAkhir(
      {final search = '', final page = 1, final status = 'MENUNGGU'}) async {
    return await _dio.get(
      "/tugas-akhir?search=$search&page=$page&filter=$status",
    );
  }

  Future<Response> updateTugasAkhir({final noRegTa = String, final data = Map<String, dynamic>}) async {
    return await _dio.put(
      "/tugas-akhir/$noRegTa",
      data: data,
    );
  }

  Future<Response> getPenguji() async {
    return await _dio.get(
      "/penguji",
    );
  }
}
