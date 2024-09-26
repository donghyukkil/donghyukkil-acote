import 'package:donghyukkil_acote/models/github_repo.dart';
import 'package:donghyukkil_acote/models/github_user.dart';

final testUsers = [
  GitHubUser(
      login: 'user1',
      id: 1,
      avatarUrl: 'assets/images/dummy1.png',
      htmlUrl: 'url1'),
  GitHubUser(
      login: 'user2',
      id: 2,
      avatarUrl: 'assets/images/dummy2.png',
      htmlUrl: 'url2'),
];

final testRepos = [
  GitHubRepo(
      id: 1,
      name: 'repo1',
      description: 'Test repository 1',
      stargazersCount: 100,
      language: 'Dart',
      htmlUrl: 'https://example.com/repo1',
      isPrivate: false,
      fullName: ''),
  GitHubRepo(
      id: 2,
      name: 'repo2',
      description: 'Test repository 2',
      stargazersCount: 150,
      language: 'JavaScript',
      htmlUrl: 'https://example.com/repo2',
      isPrivate: false,
      fullName: ''),
];
