import 'package:flutter/material.dart';

import '../models/github_repo.dart';
import '../models/github_user.dart';
import '../repositories/github_repository.dart';
import '../utils/url_launcher_helper.dart';

class DetailScreen extends StatefulWidget {
  final GitHubUser user;
  final GithubRepository githubRepository;

  const DetailScreen(
      {super.key, required this.user, required this.githubRepository});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<GitHubRepo> _repos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRepos();
  }

  Future<void> _fetchRepos() async {
    try {
      final repos =
          await widget.githubRepository.fetchUserRepos(widget.user.login);

      setState(() {
        _repos = repos;
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = false;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.login)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _repos.isEmpty
              ? const Center(
                  child: Text('No repositories found'),
                )
              : ListView.builder(
                  itemCount: _repos.length,
                  itemBuilder: (context, index) {
                    final repo = _repos[index];

                    return ListTile(
                      title: Text(repo.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(repo.description ?? 'No Description'),
                          const SizedBox(height: 4),
                          Text(
                            'Language: ${repo.language ?? 'Unknown'}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(repo.stargazersCount.toString()),
                        ],
                      ),
                      onTap: () {
                        launchUrlHelper(repo.htmlUrl);
                      },
                    );
                  }),
    );
  }
}
