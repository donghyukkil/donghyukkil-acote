import 'package:flutter/material.dart';

import '../repositories/github_repository.dart';
import '../models/github_user.dart';

class HomeScreen extends StatefulWidget {
  final GithubRepository githubRepository;

  HomeScreen({required this.githubRepository});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GitHubUser> users = [];
  int? since;
  bool isLoading = false;
  bool hasMoreData = true;
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller

  @override
  void initState() {
    super.initState();
    _fetchUsers(null);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          hasMoreData) {
        _loadMoreUsers();
      }

      if (_scrollController.position.pixels == 0 && !isLoading) {
        _refreshUsers();
      }
    });
  }

  Future<void> _fetchUsers(int? since) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await widget.githubRepository.fetchUsers(since);
      final newUsers = result['users'] as List<GitHubUser>;

      final nextSince = result['nextSince'] as int?;

      setState(() {
        if (newUsers.isEmpty) {
          hasMoreData = false;
        } else {
          users.addAll(newUsers);
          this.since = nextSince;
        }
      });
    } catch (error) {
      print('Error fetching users: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshUsers() async {
    setState(() {
      users.clear();
      since = null;
      hasMoreData = true;
    });
    await _fetchUsers(since);
  }

  Future<void> _loadMoreUsers() async {
    await _fetchUsers(since);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Users'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: users.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == users.length) {
                  return Center(child: CircularProgressIndicator());
                }

                final user = users[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Text(user.login),
                  subtitle: Text(user.htmlUrl),
                );
              },
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
