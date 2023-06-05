import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config.dart.example';
import '../api/interceptors.dart';

late final Dio dio;

class InitDio {
  call() {
    dio = Dio(
      BaseOptions(
        baseUrl: Config.apiUrl,
      ),
    )..interceptors.addAll([DioAuthInterceptors(), PrettyDioLogger()]);
  }
}
