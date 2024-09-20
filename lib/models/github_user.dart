class GitHubUser {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;
  final String? name;
  final String? bio;
  final int? publicRepos;
  final int? followers;

  GitHubUser({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    this.name,
    this.bio,
    this.publicRepos,
    this.followers,
  });

  factory GitHubUser.fromMap(Map<String, dynamic> map) {
    return GitHubUser(
      id: map['id'],
      login: map['login'],
      avatarUrl: map['avatarUrl'],
      htmlUrl: map['htmlUrl'],
      name: map['name'],
      bio: map['bio'],
      publicRepos: map['publicRepos'],
      followers: map['followers'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'login': login,
      'avatarUrl': avatarUrl,
      'htmlUrl': htmlUrl,
      'name': name,
      'bio': bio,
      'publicRepos': publicRepos,
      'followers': followers,
    };
  }

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      id: json['id'],
      login: json['login'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
      name: json['name'],
      bio: json['bio'],
      publicRepos: json['public_repos'],
      followers: json['followers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
      'name': name,
      'bio': bio,
      'public_repos': publicRepos,
      'followers': followers,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GitHubUser &&
        other.id == id &&
        other.login == login &&
        other.avatarUrl == avatarUrl &&
        other.htmlUrl == htmlUrl &&
        other.name == name &&
        other.bio == bio &&
        other.publicRepos == publicRepos &&
        other.followers == followers;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        login.hashCode ^
        avatarUrl.hashCode ^
        htmlUrl.hashCode ^
        name.hashCode ^
        bio.hashCode ^
        publicRepos.hashCode ^
        followers.hashCode;
  }

  GitHubUser copyWith({
    String? login,
    int? id,
    String? avatarUrl,
    String? htmlUrl,
    String? name,
    String? bio,
    int? publicRepos,
    int? followers,
  }) {
    return GitHubUser(
      id: id ?? this.id,
      login: login ?? this.login,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      publicRepos: publicRepos ?? this.publicRepos,
      followers: followers ?? this.followers,
    );
  }
}
