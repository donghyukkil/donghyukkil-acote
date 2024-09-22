part of 'github_users_bloc.dart';

sealed class GithubUsersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGithubUsers extends GithubUsersEvent {
  final int? since;

  FetchGithubUsers(this.since);

  @override
  List<Object?> get props => [since];
}

class RefreshGithubUsers extends GithubUsersEvent {}
