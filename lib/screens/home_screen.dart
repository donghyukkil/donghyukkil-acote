import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/github_user.dart';
import '../repositories/github_repository.dart';
import '../bloc/users/github_users_bloc.dart';
import '../utils/url_launcher_helper.dart';
import '../screens/detail_screen.dart';

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
        title: const Text('GitHub Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                itemCount: users.length + 1,
                itemBuilder: (context, index) {
                  if (index == users.length) {
                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!hasMoreData) {
                      return const Center(child: Text('No more data to load'));
                    }
                  }

                  // 해당 인덱스가 리스트 범위 밖으로 벗어나지 않도록 체크
                  if (index < users.length) {
                    final item = users[index];

                    // 광고 배너 렌더링
                    if (item == 'ad') {
                      return GestureDetector(
                        onTap: () => launchUrlHelper('https://taxrefundgo.kr'),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              shape: BoxShape.rectangle,
                              border: const Border(
                                top: BorderSide(color: Colors.black, width: 2),
                                left: BorderSide(color: Colors.black, width: 2),
                                right:
                                    BorderSide(color: Colors.black, width: 2),
                                bottom:
                                    BorderSide(color: Colors.black, width: 7),
                              ),
                            ),
                            child: Image.network(
                              'https://placehold.it/500x100?text=ad',
                            ),
                          ),
                        ),
                      );
                    }

                    // 유저 데이터 렌더링
                    if (item is GitHubUser) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            shape: BoxShape.rectangle,
                            border: const Border(
                              top: BorderSide(color: Colors.black, width: 2),
                              left: BorderSide(color: Colors.black, width: 2),
                              right: BorderSide(color: Colors.black, width: 2),
                              bottom: BorderSide(color: Colors.black, width: 7),
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          user: item,
                                          githubRepository:
                                              widget.githubRepository)));
                            },
                            leading: SizedBox(
                              width: 80,
                              height: 80,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(item.avatarUrl),
                              ),
                            ),
                            title: Row(
                              children: [
                                SizedBox(width: 4),
                                Row(
                                  children: [
                                    Text('${index + 1}.'),
                                    SizedBox(width: 10),
                                    Text(item.login),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return null;
                },
              );
            }

            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
