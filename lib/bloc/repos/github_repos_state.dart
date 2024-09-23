part of 'github_repos_bloc.dart';

sealed class GithubReposState extends Equatable {
  const GithubReposState();

  @override
  List<Object> get props => [];
}

class RepoLoading extends GithubReposState {}

class RepoLoaded extends GithubReposState {
  final List<GitHubRepo> repos;

  const RepoLoaded(this.repos);

  @override
  List<Object> get props => [repos];
}

class RepoError extends GithubReposState {
  final String message;

  const RepoError(this.message);

  @override
  List<Object> get props => [message];
}
