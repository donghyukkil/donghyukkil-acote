part of 'github_users_bloc.dart';

sealed class GithubUsersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GithubUserInitial extends GithubUsersState {}

class GithubUserLoading extends GithubUsersState {
  final List<dynamic> users;

  GithubUserLoading({
    this.users = const [],
  });
}

class GithubUserLoaded extends GithubUsersState {
  final List<dynamic> users;
  final int? nextSince;
  final bool hasMoreData;

  GithubUserLoaded(
      {required this.users, this.nextSince, this.hasMoreData = true});

  @override
  List<Object?> get props => [users, nextSince, hasMoreData];
}

class GithubUserError extends GithubUsersState {
  final String error;

  GithubUserError(this.error);

  @override
  List<Object?> get props => [error];
}
