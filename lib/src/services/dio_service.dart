import 'package:dio/dio.dart';

class DioService {
  // Wikipedia Api
  String wikipediaApi = 'https://en.wikipedia.org//w/api.php';

  static var options = BaseOptions(
    connectTimeout: const Duration(milliseconds: 5000),
    // receiveTimeout: 3000,
  );
  Dio dioService = Dio(options);
}
