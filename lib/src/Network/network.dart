import 'package:dio/dio.dart';

typedef OnSuccess = void Function(Map<String, dynamic> onSuccess);
typedef OnError = void Function(Object error, StackTrace stackTrace);

abstract class BaseClient {
  const BaseClient();

  Future<void> consumeGetRequest(
    String path,
    OnSuccess onSuccess,
    OnError onError,
  );
}

class DioClient extends BaseClient {
  DioClient() : _dio = Dio();

  final Dio _dio;

  @override
  Future<void> consumeGetRequest(
    String path,
    OnSuccess onSuccess,
    OnError onError,
  ) async {
    try {
      final data = await _dio.get(path);
      onSuccess(data.data);
    } catch (e, s) {
      onError(e, s);
    }
  }
}
