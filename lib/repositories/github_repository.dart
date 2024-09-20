import 'package:dio/dio.dart';

import '../models/github_user.dart';
import '../utils/link_header_utils.dart';

// Note: this class interacts with the Github API.
// this class contain methods to fetch Github users
// and to fetch repositories for a specific user.

class GithubRepository {
  final Dio _dio;

  GithubRepository(this._dio);

  Future<Map<String, dynamic>> fetchUsers(int? since) async {
    try {
      final response = await _dio.get(
        'https://api.github.com/users',
        queryParameters: {
          if (since != null) 'since': since,
          'per_page': 10,
        },
      );

      if (response.statusCode == 200) {
        List<GitHubUser> users = (response.data as List)
            .map((userJson) => GitHubUser.fromJson(userJson))
            .toList();

        // Note: Extract the next "since" value from the Link header
        final linkHeader = response.headers['link']?[0];

        int? nextSince = extractSinceFromLinkHeader(linkHeader);

        return {'users': users, 'nextSince': nextSince};
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      throw Exception('Error fetching users: $error');
    }
  }
}
