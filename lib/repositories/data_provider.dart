import 'package:dio/dio.dart';

import '../core/constants.dart';

class GithubApiProvider {
  final Dio _dio;
  final String? _token;

  GithubApiProvider(this._dio, [this._token = '']);

  Future<Response> fetchUsers(int? since) async {
    final options = Options(headers: {
      if (_token!.isNotEmpty) 'Authorization': 'token $_token',
    });

    return await _dio.get(
      '$baseUrl/users',
      queryParameters: {
        if (since != null) 'since': since,
        'per_page': perPage,
      },
      options: options,
    );
  }

  Future<Response> fetchUserRepos(String userName, {int page = 1}) async {
    return await _dio.get('$baseUrl/users/$userName/repos', queryParameters: {
      'page': page,
      'per_page': perPage,
    });
  }
}
