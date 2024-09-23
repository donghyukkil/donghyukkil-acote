import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/github_user.dart';
import '../repositories/github_repository.dart';
import '../utils/color_converter.dart';
import '../utils/url_launcher_helper.dart';
import '../bloc/repos/github_repos_bloc.dart';
import '../core/constants.dart';

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
        appBar: AppBar(
            backgroundColor: backgroundColor,
            title: Text(
              '${user.login} repos',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
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

            //todo 기능 개선, users/특정 사용자로 bio, name, follows로 user모델 업데이트. input 사용자 검색
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              color: Colors.white,
              child: ListView.builder(
                  itemCount: state.repos.length,
                  itemBuilder: (context, index) {
                    final repo = state.repos[index];
                    final languageColor =
                        languageColors[repo.language] ?? '#000000';

                    return ListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(user.avatarUrl)),
                          const SizedBox(width: 10),
                          Text(
                            user.login,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repo.name,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(repo.description ?? 'No description'),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.yellow),
                                  const SizedBox(width: 5),
                                  Text(repo.stargazersCount.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(width: 15),
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: getColorFromHex(languageColor),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                repo.language ?? 'Not Specified',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          const Divider(height: 1, thickness: 2),
                        ],
                      ),
                      onTap: () {
                        launchUrlHelper(repo.htmlUrl);
                      },
                    );
                  }),
            );
          }

          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
