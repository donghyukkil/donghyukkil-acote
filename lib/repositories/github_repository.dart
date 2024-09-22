import '../models/github_user.dart';
import '../models/github_repo.dart';

import '../utils/link_header_utils.dart';
import 'data_provider.dart';

// Note: this class interacts with the Github API.
// this class contain methods to fetch Github users
// and to fetch repositories for a specific user.

enum HttpStatusCode {
  ok(200),
  badRequest(400),
  unauthorized(401),
  notFound(404),
  internalServerError(500);

  final int code;
  const HttpStatusCode(this.code);
}

class GithubRepository {
  final GithubApiProvider _apiProvider;

  GithubRepository(this._apiProvider);

  Future<Map<String, dynamic>> fetchUsers(int? since) async {
    try {
      final response = await _apiProvider.fetchUsers(since);

      if (response.statusCode == HttpStatusCode.ok.code) {
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

  Future<List<GitHubRepo>> fetchUserRepos(String userName) async {
    try {
      final response = await _apiProvider.fetchUserRepos(userName);

      if (response.statusCode == HttpStatusCode.ok.code) {
        List<GitHubRepo> repos = (response.data as List)
            .map((repoJson) => GitHubRepo.fromJson(repoJson))
            .toList();
        return repos;
      } else {
        throw Exception('Failed to load repos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load repos $e');
    }
  }
}
