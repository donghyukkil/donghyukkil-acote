import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'repositories/data_provider.dart';
import 'repositories/github_repository.dart';
import 'screens/home_screen.dart';
import 'bloc/users/github_users_bloc.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final dio = Dio();

  final apiToken = dotenv.env['GITHUB_API_TOKEN'] ?? '';
  final apiProvider = GithubApiProvider(dio, apiToken);
  final githubRepository = GithubRepository(apiProvider);

  runApp(MyApp(githubRepository: githubRepository));
}

class MyApp extends StatelessWidget {
  final GithubRepository githubRepository;

  const MyApp({super.key, required this.githubRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GithubUsersBloc(githubRepository),
      child: MaterialApp(
        title: 'GitHub Users App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(githubRepository: githubRepository),
      ),
    );
  }
}
