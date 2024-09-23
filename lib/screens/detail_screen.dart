import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/github_user.dart';
import '../repositories/github_repository.dart';
import '../utils/url_launcher_helper.dart';
import '../bloc/repos/github_repos_bloc.dart';

class DetailScreen extends StatelessWidget {
  final GitHubUser user;
  final GithubRepository githubRepository;

  const DetailScreen(
      {super.key, required this.user, required this.githubRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GithubReposBloc(githubRepository)..add(FetchRepos(user.login)),
      child: Scaffold(
        appBar: AppBar(title: Text(user.login)),
        body: BlocBuilder<GithubReposBloc, GithubReposState>(
            builder: (context, state) {
          if (state is RepoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RepoError) {
            return Center(child: Text(state.message));
          } else if (state is RepoLoaded) {
            if (state.repos.isEmpty) {
              return const Center(child: Text('No repositories found'));
            }

            return ListView.builder(
                itemCount: state.repos.length,
                itemBuilder: (context, index) {
                  final repo = state.repos[index];

                  return ListTile(
                    title: Text(repo.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(repo.description ?? 'No Description'),
                        const SizedBox(height: 4),
                        Text('Language: ${repo.language ?? 'Unknown'}',
                            style: const TextStyle(color: Colors.grey))
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        Text(repo.stargazersCount.toString()),
                      ],
                    ),
                    onTap: () {
                      launchUrlHelper(repo.htmlUrl);
                    },
                  );
                });
          }

          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
