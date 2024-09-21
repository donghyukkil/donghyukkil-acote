import 'package:dio/dio.dart';

class GithubApiProvider {
  final Dio _dio;

  GithubApiProvider(this._dio);

  Future<Response> fetchUsers(int? since) async {
    return await _dio.get(
      'https://api.github.com/users',
      queryParameters: {
        if (since != null) 'since': since,
        'per_page': 10,
      },
    );
  }
}
