part of 'github_repos_bloc.dart';

sealed class GithubReposEvent extends Equatable {
  const GithubReposEvent();

  @override
  List<Object> get props => [];
}

class FetchRepos extends GithubReposEvent {
  final String userName;
  final int page;

  const FetchRepos(this.userName, {this.page = 1});

  @override
  List<Object> get props => [userName];
}
