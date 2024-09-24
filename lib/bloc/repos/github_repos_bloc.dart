import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/github_repo.dart';
import '../../repositories/github_repository.dart';

part 'github_repos_event.dart';
part 'github_repos_state.dart';

class GithubReposBloc extends Bloc<GithubReposEvent, GithubReposState> {
  final GithubRepository githubRepository;

  GithubReposBloc(this.githubRepository) : super(const RepoLoading()) {
    on<FetchRepos>(_onFetchRepos);
  }

  Future<void> _onFetchRepos(
      FetchRepos event, Emitter<GithubReposState> emit) async {
    try {
      final currentState = state;
      List<GitHubRepo> currentRepos = [];

      if (currentState is RepoLoaded) {
        // Note: Keep previously loaded repos for pagination
        currentRepos = currentState.repos;
      }

      // Note: Show loading state while keeping existing repos visible
      emit(RepoLoading(repos: currentRepos));

      final result = await githubRepository.fetchUserRepos(event.userName,
          page: event.page);

      final repos = result['repos'] as List<GitHubRepo>;
      final nextPage = result['nextPage'] as int?;

      if (repos.isNotEmpty) {
        emit(RepoLoaded(
          [...currentRepos, ...repos],
          nextPage: nextPage,
        ));
      } else {
        emit(NoMoreRepos());
      }
    } catch (e) {
      // todo:  differentiate between different types of errors (like network issues or API limit errors)
      emit(RepoError('Failed to fetch repositories $e'));
    }
  }

  @override
  void onEvent(GithubReposEvent event) {
    super.onEvent(event);
    // print('Event: $event');
  }

  @override
  void onChange(Change<GithubReposState> change) {
    super.onChange(change);
    // print(
    //     'State Change - Previous: ${change.currentState}, Next: ${change.nextState}');
  }

  @override
  void onTransition(Transition<GithubReposEvent, GithubReposState> transition) {
    super.onTransition(transition);
    // print(
    //     'Transition - Event: ${transition.event}, From: ${transition.currentState}, To: ${transition.nextState}');
  }
}
