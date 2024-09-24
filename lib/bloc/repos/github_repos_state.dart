part of 'github_repos_bloc.dart';

sealed class GithubReposState extends Equatable {
  const GithubReposState();

  @override
  List<Object?> get props => [];
}

class RepoLoading extends GithubReposState {
  final List<GitHubRepo> repos;

  const RepoLoading({this.repos = const []});

  @override
  List<Object> get props => [repos];
}

class RepoLoaded extends GithubReposState {
  final List<GitHubRepo> repos;
  final int? nextPage;

  const RepoLoaded(this.repos, {this.nextPage});

  @override
  List<Object?> get props => [repos, nextPage];
}

class NoMoreRepos extends GithubReposState {}

class RepoError extends GithubReposState {
  final String message;

  const RepoError(this.message);

  @override
  List<Object> get props => [message];
}
