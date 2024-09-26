import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/github_user.dart';
import '../utils/color_converter.dart';
import '../utils/url_launcher_helper.dart';
import '../bloc/repos/github_repos_bloc.dart';
import '../core/constants.dart';

class DetailScreen extends StatefulWidget {
  final GitHubUser user;

  const DetailScreen({super.key, required this.user});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<GithubReposBloc>().add(FetchRepos(widget.user.login));

    _scrollController.addListener(() {
      final state = context.read<GithubReposBloc>().state;

      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          state is RepoLoaded) {
        if (state.nextPage != null) {
          context
              .read<GithubReposBloc>()
              .add(FetchRepos(widget.user.login, page: state.nextPage!));
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            '${widget.user.login} repos',
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
      body: BlocBuilder<GithubReposBloc, GithubReposState>(
          builder: (context, state) {
        if (state is RepoLoading && state.repos.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RepoError) {
          return Center(child: Text(state.message));
        } else if (state is RepoLoaded || state is RepoLoading) {
          final repos = (state is RepoLoaded)
              ? state.repos
              : (state as RepoLoading).repos;
          final isLoading = state is RepoLoading;
          final hasMoreData = state is RepoLoaded && state.nextPage != null;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            color: Colors.white,
            child: ListView.builder(
                controller: _scrollController,
                itemCount: repos.length + 1,
                itemBuilder: (context, index) {
                  if (index == repos.length) {
                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!hasMoreData) {
                      return const Center(child: Text('No more data to load'));
                    }
                  }

                  if (index < repos.length) {
                    final repo = repos[index];
                    final languageColor =
                        languageColors[repo.language] ?? '#000000';

                    return ListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                              radius: 18,
                              backgroundImage:
                                  NetworkImage(widget.user.avatarUrl)),
                          const SizedBox(width: 10),
                          Text(
                            widget.user.login,
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
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(height: 1, thickness: 2),
                        ],
                      ),
                      onTap: () {
                        launchUrlHelper(repo.htmlUrl);
                      },
                    );
                  }
                  return null;
                }),
          );
        }

        return const Center(child: Text('No data available'));
      }),
    );
  }
}
