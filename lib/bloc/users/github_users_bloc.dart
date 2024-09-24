import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/github_repository.dart';
import '../../models/github_user.dart';

part 'github_users_event.dart';
part 'github_users_state.dart';

class GithubUsersBloc extends Bloc<GithubUsersEvent, GithubUsersState> {
  final GithubRepository githubRepository;

  List<GitHubUser> pureUserList = [];

  GithubUsersBloc(this.githubRepository) : super(GithubUserInitial()) {
    on<FetchGithubUsers>(_onFetchUsers);
    on<RefreshGithubUsers>(_onRefreshUsers);
  }

  @override
  void onEvent(GithubUsersEvent event) {
    super.onEvent(event);
    // print('Event: $event');
  }

  @override
  void onChange(Change<GithubUsersState> change) {
    super.onChange(change);
    // print('Previous state: ${change.currentState}');
    // print('Current state: ${change.nextState}');
  }

  @override
  void onTransition(Transition<GithubUsersEvent, GithubUsersState> transition) {
    super.onTransition(transition);
    // print(
    //     'Event: ${transition.event}, Previous State: ${transition.currentState}, Next State: ${transition.nextState}');
  }

  Future<void> _onFetchUsers(
      FetchGithubUsers event, Emitter<GithubUsersState> emit) async {
    final currentState = state;
    List<dynamic> usersWithAds = [];

    if (currentState is GithubUserLoaded) {
      usersWithAds =
          currentState.users.where((user) => user is GitHubUser).toList();
    }

    emit(GithubUserLoading(
      users: usersWithAds,
    ));

    try {
      final result = await githubRepository.fetchUsers(event.since);
      final newUsers = result['users'] as List<GitHubUser>;
      final nextSince = result['nextSince'] as int?;
      final hasMoreData = nextSince != null;

      pureUserList.addAll(newUsers);

      // Note: This comment is used to simulate an API returning null when there is no more data available.
      // When the view receives hasMoreData = false, the last item in the list will display a "No more data to load" message.

      // final hasMoreData = false;

      emit(GithubUserLoaded(
        users: pureUserList,
        nextSince: nextSince,
        hasMoreData: hasMoreData,
      ));
    } catch (e) {
      emit(GithubUserError('Failed to fetch users $e'));
    }
  }

  Future<void> _onRefreshUsers(
      RefreshGithubUsers event, Emitter<GithubUsersState> emit) async {
    emit(GithubUserLoading());

    try {
      final result = await githubRepository.fetchUsers(null);
      pureUserList = result['users'] as List<GitHubUser>;
      final nextSince = result['nextSince'] as int?;

      emit(GithubUserLoaded(
        users: pureUserList,
        nextSince: nextSince,
      ));
    } catch (e) {
      emit(GithubUserError('Failed to refresh users $e'));
    }
  }
}
