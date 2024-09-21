import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'repositories/data_provider.dart';
import 'repositories/github_repository.dart';
import 'screens/home_screen.dart';

void main() {
  final dio = Dio();
  final apiProvider = GithubApiProvider(dio);
  final githubRepository = GithubRepository(apiProvider);

  runApp(MyApp(githubRepository: githubRepository));
}

class MyApp extends StatelessWidget {
  final GithubRepository githubRepository;

  const MyApp({required this.githubRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Users App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(githubRepository: githubRepository),
    );
  }
}
