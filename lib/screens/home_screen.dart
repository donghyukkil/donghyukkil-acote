import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/github_user.dart';
import '../repositories/github_repository.dart';
import '../bloc/users/github_users_bloc.dart';
import '../bloc/repos/github_repos_bloc.dart';
import '../utils/list_utils.dart';
import '../utils/url_launcher_helper.dart';
import '../screens/detail_screen.dart';
import '../core/constants.dart';

class HomeScreen extends StatefulWidget {
  final GithubRepository githubRepository;

  const HomeScreen({super.key, required this.githubRepository});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<GithubUsersBloc>().add(FetchGithubUsers(null));

    _scrollController.addListener(() {
      final state = context.read<GithubUsersBloc>().state;

      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          state is GithubUserLoaded &&
          state.hasMoreData) {
        context.read<GithubUsersBloc>().add(FetchGithubUsers(state.nextSince));
      }

      if (_scrollController.position.pixels == 0) {
        context.read<GithubUsersBloc>().add(RefreshGithubUsers());
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
        title: const Text(
          'GitHub Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: BlocBuilder<GithubUsersBloc, GithubUsersState>(
          builder: (context, state) {
            if (state is GithubUserError) {
              return Center(child: Text(state.error));
            }

            if (state is GithubUserLoading && state.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GithubUserLoaded || state is GithubUserLoading) {
              final users = (state is GithubUserLoaded)
                  ? state.users
                  : (state as GithubUserLoading).users;
              final isLoading = state is GithubUserLoading;
              final hasMoreData =
                  state is GithubUserLoaded && state.hasMoreData;

              return ListView.builder(
                controller: _scrollController,
                itemCount:
                    calculateTotalItemCount(users.length, adInterval) + 1,
                itemBuilder: (context, index) {
                  if (index < users.length) {
                    final actualIndex = index - (index ~/ (adInterval + 1));

                    // Note: Ads will be displayed before Parent Item.
                    if (shouldInsertAd(index, adInterval)) {
                      return _buildAdWidget();
                    }

                    if (actualIndex < users.length) {
                      final item = users[actualIndex];

                      // GitHub user data rendering
                      if (item is GitHubUser) {
                        return _buildUserItem(item, actualIndex);
                      }
                    }

                    if (index == users.length) {
                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!hasMoreData) {
                        return const Center(
                            child: Text('No more data to load'));
                      }
                    }

                    return const SizedBox.shrink();
                  }
                  return const SizedBox.shrink();
                },
              );
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildUserItem(GitHubUser item, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => GithubReposBloc(widget.githubRepository),
              child: DetailScreen(
                  user: item, githubRepository: widget.githubRepository),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 70,
              height: 60,
              child:
                  CircleAvatar(backgroundImage: NetworkImage(item.avatarUrl)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No. ${index + 1}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    item.login,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.name ?? 'No name provided',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Text(
                    item.bio ?? 'No bio available',
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.grey),
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => launchUrlHelper('https://taxrefundgo.kr'),
            child: Image.network('https://placehold.it/500x100?text=ad'),
          ),
          const Divider(thickness: 1, color: Colors.grey),
        ],
      ),
    );
  }
}
