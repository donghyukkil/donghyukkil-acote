import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:donghyukkil_acote/screens/detail_screen.dart';
import 'package:donghyukkil_acote/bloc/repos/github_repos_bloc.dart';
import '../test_data.dart';

// Mock dependencies
class MockGithubReposBloc extends MockBloc<GithubReposEvent, GithubReposState>
    implements GithubReposBloc {}

void main() {
  late MockGithubReposBloc mockGithubReposBloc;

  setUp(() {
    mockGithubReposBloc = MockGithubReposBloc();
  });

  tearDown(() {
    mockGithubReposBloc.close();
  });

  group('DetailScreen Widget Tests', () {
    testWidgets('should load more repos when scrolled to the bottom',
        (WidgetTester tester) async {
      // Arrange: BLoC emits loaded state with sample repos

      when(() => mockGithubReposBloc.state).thenReturn(
        RepoLoaded(testRepos, nextPage: 2),
      );

      // Mock the network image
      await mockNetworkImages(() async {
        // Act: Render the widget
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<GithubReposBloc>.value(
              value: mockGithubReposBloc,
              child: DetailScreen(user: testUsers[0]),
            ),
          ),
        );

        // NOTE: Ensure widget tree is built
        await tester.pumpAndSettle();

        // Act: Scroll to the bottom
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump(const Duration(milliseconds: 500));

        // Assert: Verify that more repos are fetched
        verify(() => mockGithubReposBloc
            .add(FetchRepos(testUsers[0].login, page: 2))).called(1);
      });
    });

    testWidgets(
        'should show "No more data to load" when no more repos are available',
        (WidgetTester tester) async {
      // Arrange: BLoC emits loaded state with no more repos to load

      when(() => mockGithubReposBloc.state).thenReturn(
        RepoLoaded(testRepos,
            nextPage: null), // NOTE: nextPage: null means "No next page"!.
      );

      await mockNetworkImages(() async {
        // Act: Render the widget
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<GithubReposBloc>.value(
              value: mockGithubReposBloc,
              child: DetailScreen(user: testUsers[0]),
            ),
          ),
        );

        // Ensure widget tree is built
        await tester.pumpAndSettle();

        // Act: Scroll to the bottom
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();

        // Assert: Verify "No more data to load" is displayed
        expect(find.text('No more data to load'), findsOneWidget);
      });
    });
  });
}
