import 'package:dio/dio.dart';

class GithubApiProvider {
  final Dio _dio;
  final String? _token;

  GithubApiProvider(this._dio, [this._token = '']);

  Future<Response> fetchUsers(int? since) async {
    final options = Options(headers: {
      if (_token!.isNotEmpty) 'Authorization': 'token $_token',
    });

    return await _dio.get(
      'https://api.github.com/users',
      queryParameters: {
        if (since != null) 'since': since,
        'per_page': 10,
      },
      options: options,
    );
  }
}
