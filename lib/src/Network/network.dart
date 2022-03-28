import 'package:dio/dio.dart';

typedef OnSuccess = void Function(Map<String, dynamic> onSuccess);

abstract class BaseClient {
  const BaseClient();
  consumeGetRequest(String path, OnSuccess onSuccess);
}

class DioClient extends BaseClient {
  DioClient() : _dio = Dio();

  final Dio _dio;

  @override
  consumeGetRequest(String path, OnSuccess onSuccess) async {
    final data = await _dio.get(path);
    onSuccess(data.data);
  }
}
