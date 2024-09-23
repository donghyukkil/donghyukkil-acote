part of 'github_repos_bloc.dart';

sealed class GithubReposEvent extends Equatable {
  const GithubReposEvent();

  @override
  List<Object> get props => [];
}

class FetchRepos extends GithubReposEvent {
  final String userName;

  const FetchRepos(this.userName);

  @override
  List<Object> get props => [userName];
}
