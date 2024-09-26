import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:donghyukkil_acote/screens/home_screen.dart';
import 'package:donghyukkil_acote/repositories/github_repository.dart';
import 'package:donghyukkil_acote/bloc/users/github_users_bloc.dart';

import '../test_data.dart';

// Mock dependencies
class MockGithubRepository extends Mock implements GithubRepository {}

class MockGithubUsersBloc extends MockBloc<GithubUsersEvent, GithubUsersState>
    implements GithubUsersBloc {}

void main() {
  late MockGithubRepository mockGithubRepository;
  late MockGithubUsersBloc mockGithubUsersBloc;

  setUp(() {
    mockGithubRepository = MockGithubRepository();
    mockGithubUsersBloc = MockGithubUsersBloc();
  });

  tearDown(() {
    mockGithubUsersBloc.close();
  });

  group('HomeScreen Widget Tests', () {
    testWidgets(
        'should display loading indicator while loading users on initial load',
        (WidgetTester tester) async {
      // Arrange: BLoC emits loading state
      when(() => mockGithubUsersBloc.state)
          .thenReturn(GithubUserLoading(users: []));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<GithubUsersBloc>.value(
            value: mockGithubUsersBloc,
            child: HomeScreen(githubRepository: mockGithubRepository),
          ),
        ),
      );

      // Assert: Verify CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.textContaining('Error'), findsNothing);
    });

    testWidgets('should display list of users when data is loaded',
        (WidgetTester tester) async {
      // Arrange: BLoC emits loaded state with sample users

      when(() => mockGithubUsersBloc.state).thenReturn(
          GithubUserLoaded(users: testUsers, nextSince: 2, hasMoreData: true));

      await mockNetworkImages(() async {
        // Act: Render the widget
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<GithubUsersBloc>.value(
              value: mockGithubUsersBloc,
              child: HomeScreen(githubRepository: mockGithubRepository),
            ),
          ),
        );

        // Ensure widget tree is built
        await tester.pumpAndSettle();

        // Assert: Verify the user list is displayed
        expect(find.text('user1'), findsOneWidget);
        expect(find.text('user2'), findsOneWidget);
      });
    });

    testWidgets('should trigger search when input text is changed',
        (WidgetTester tester) async {
      // Arrange: BLoC should emit loading and then search result
      when(() => mockGithubUsersBloc.state)
          .thenReturn(GithubUserLoading(users: []));

      when(() => mockGithubUsersBloc.add(SearchGithubUsers('user3')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<GithubUsersBloc>.value(
            value: mockGithubUsersBloc,
            child: HomeScreen(githubRepository: mockGithubRepository),
          ),
        ),
      );

      // Act: Type a search query
      await tester.enterText(find.byType(TextField), 'user3');
      await tester.pump(const Duration(milliseconds: 500));

      // Assert: Verify that the search event is added to the BLoC
      verify(() => mockGithubUsersBloc.add(SearchGithubUsers('user3')))
          .called(1);
    });
  });
}
