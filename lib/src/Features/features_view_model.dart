import 'package:dio/dio.dart';

abstract class BaseClient {
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });
}

class DioClient extends BaseClient {
  DioClient() : _dio = Dio();

  final Dio _dio;

  @override
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.get(
      uri,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
