import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:donghyukkil_acote/bloc/users/github_users_bloc.dart';
import 'package:donghyukkil_acote/repositories/github_repository.dart';
import 'package:donghyukkil_acote/models/github_user.dart';

import '../../../test_data.dart';

// Mock the dependencies
class MockGithubRepository extends Mock implements GithubRepository {}

void main() {
  late GithubUsersBloc githubUsersBloc;
  late MockGithubRepository mockGithubRepository;

  setUp(() {
    mockGithubRepository = MockGithubRepository();
    githubUsersBloc = GithubUsersBloc(mockGithubRepository);
  });

  tearDown(() {
    githubUsersBloc.close();
  });

  group('GithubUsersBloc', () {
    blocTest<GithubUsersBloc, GithubUsersState>(
      'Test case 1: Fetching users successfully',

      // Arrange: Mock the repository`s fetchUsers method to return testUsers and nextSince = 2.
      // NOTE: In the build function, mock the fetchUsers method of the repository
      // to return a list of users and the next 'since' value for pagination.
      build: () {
        when(() => mockGithubRepository.fetchUsers(null))
            .thenAnswer((_) async => {'users': testUsers, 'nextSince': 2});
        return githubUsersBloc;
      },

      // Act: Trigger the FetchGithubUsers event with 'since' set to null.
      act: (bloc) => bloc.add(FetchGithubUsers(null)),

      // Assert: Check that the bloc emits a loading state followed by a loaded state.
      expect: () => [
        GithubUserLoading(users: []),
        GithubUserLoaded(users: testUsers, nextSince: 2, hasMoreData: true),
      ],
    );

    blocTest<GithubUsersBloc, GithubUsersState>(
      'Test case 2: Handling errors when fetching users',

      // Arrange: Mock the repository`s fetchUsers method to throw an exception.
      build: () {
        when(() => mockGithubRepository.fetchUsers(null))
            .thenThrow(Exception('Failed to load users'));
        return githubUsersBloc;
      },

      // Act: Trigger the FetchGithubUsers event with 'since' set to null.
      act: (bloc) => bloc.add(FetchGithubUsers(null)),

      // Assert: Check that the bloc emits a loading state followed by an error state.
      expect: () => [
        GithubUserLoading(users: []),
        GithubUserError(
            'Failed to fetch users Exception: Failed to load users'),
      ],
    );

    blocTest<GithubUsersBloc, GithubUsersState>(
      'Test case 3: Searching users with specific input',

      // Arrange: Mock the searchUsers method to return empty results for 'user3' and a valid for 'user1'.
      build: () {
        when(() => mockGithubRepository.searchUsers('user3'))
            .thenAnswer((_) async => []);
        when(() => mockGithubRepository.searchUsers('user1')).thenAnswer(
            (_) async => [
                  GitHubUser(
                      id: 1, login: 'user', avatarUrl: 'test', htmlUrl: 'test')
                ]);

        return githubUsersBloc;
      },

      // Act: Trigger the SearchGithubUsers evenrt with 'user3' as the input query.
      act: (bloc) => bloc.add(SearchGithubUsers('user3')),

      // Assert: Check that the bloc emits a loading state followed by a loaded state with no users.
      expect: () => [
        GithubUserLoading(users: []),
        GithubUserLoaded(users: []),
      ],
    );

    blocTest<GithubUsersBloc, GithubUsersState>(
      'case 4: Refreshing the list of users successfully',

      // Arrange: Mock the repository's fetchUsers method to return testUsers and nextSince = 1.
      build: () {
        when(() => mockGithubRepository.fetchUsers(null))
            .thenAnswer((_) async => {'users': testUsers, 'nextSince': 1});
        return githubUsersBloc;
      },

      // Act: Trigger the RefreshGithubUsers event.
      act: (bloc) => bloc.add(RefreshGithubUsers()),

      // Assert: Check that the bloc emits a loading state followed by a loaded state with refreshed users.
      expect: () => [
        GithubUserLoading(),
        GithubUserLoaded(users: testUsers, nextSince: 1),
      ],
    );
  });
}
