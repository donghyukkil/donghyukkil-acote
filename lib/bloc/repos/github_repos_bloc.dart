import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/github_repo.dart';
import '../../repositories/github_repository.dart';

part 'github_repos_event.dart';
part 'github_repos_state.dart';

class GithubReposBloc extends Bloc<GithubReposEvent, GithubReposState> {
  final GithubRepository githubRepository;

  GithubReposBloc(this.githubRepository) : super(RepoLoading()) {
    on<FetchRepos>(_onFetchRepos);
  }

  Future<void> _onFetchRepos(
      FetchRepos event, Emitter<GithubReposState> emit) async {
    try {
      emit(RepoLoading());

      final repos = await githubRepository.fetchUserRepos(event.userName);
      emit(RepoLoaded(repos));
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
    print(
        'Transition - Event: ${transition.event}, From: ${transition.currentState}, To: ${transition.nextState}');
  }
}
