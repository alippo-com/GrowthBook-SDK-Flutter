import 'package:dio/dio.dart';

abstract class BaseClient {
  const BaseClient();
  Future<Map<String, dynamic>> consumeGetRequest(String path);
}

class DioClient extends BaseClient {
  DioClient() : _dio = Dio();

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> consumeGetRequest(String path) async {
    final data = await _dio.get(path);
    return data.data;
  }
}
