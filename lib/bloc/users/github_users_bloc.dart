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
    on<SearchGithubUsers>(_onSearchUsers);
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
    if (event.since == null && pureUserList.isNotEmpty) {
      // Note: Using cached data
      emit(GithubUserLoaded(users: pureUserList, hasMoreData: true));

      return;
    }

    emit(GithubUserLoading(users: pureUserList));

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

  Future<void> _onSearchUsers(
      SearchGithubUsers event, Emitter<GithubUsersState> emit) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      if (pureUserList.isNotEmpty) {
        // 사용자가 입력값을 모두 삭제했으므로, pureUserList를 다시 사용
        emit(GithubUserLoaded(users: pureUserList, hasMoreData: true));
      } else {
        // 캐시된 데이터가 없으면 다시 데이터를 패칭
        emit(GithubUserLoading());
        add(FetchGithubUsers(null)); // FetchGithubUsers 이벤트 재실행
      }
      return;
    }

    if (state is GithubUserLoaded) {
      emit(GithubUserLoading(users: (state as GithubUserLoaded).users));
    } else if (state is GithubUserLoading) {
      emit(GithubUserLoading(users: (state as GithubUserLoading).users));
    } else {
      emit(GithubUserLoading(users: []));
    }

    try {
      final result = await githubRepository.searchUsers(event.query);
      emit(GithubUserLoaded(users: result));
    } catch (e) {
      emit(GithubUserError('Failed to search users'));
    }
  }
}
