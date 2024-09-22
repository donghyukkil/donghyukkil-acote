class GitHubRepo {
  final int id;
  final String name;
  final String fullName;
  final bool isPrivate;
  final String htmlUrl;
  final String? description;
  final int stargazersCount;
  final String? language;

  GitHubRepo({
    required this.id,
    required this.name,
    required this.fullName,
    required this.isPrivate,
    required this.htmlUrl,
    this.description,
    required this.stargazersCount,
    this.language,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
      isPrivate: json['private'],
      htmlUrl: json['html_url'],
      description: json['description'],
      stargazersCount: json['stargazers_count'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'private': isPrivate,
      'html_url': htmlUrl,
      'description': description,
      'stargazers_count': stargazersCount,
      'language': language,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GitHubRepo &&
        other.id == id &&
        other.name == name &&
        other.fullName == fullName &&
        other.isPrivate == isPrivate &&
        other.htmlUrl == htmlUrl &&
        other.description == description &&
        other.stargazersCount == stargazersCount &&
        other.language == language;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        fullName.hashCode ^
        isPrivate.hashCode ^
        htmlUrl.hashCode ^
        description.hashCode ^
        stargazersCount.hashCode ^
        language.hashCode;
  }

  GitHubRepo copyWith({
    int? id,
    String? name,
    String? fullName,
    bool? isPrivate,
    String? htmlUrl,
    String? description,
    int? stargazersCount,
    String? language,
  }) {
    return GitHubRepo(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      isPrivate: isPrivate ?? this.isPrivate,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      description: description ?? this.description,
      stargazersCount: stargazersCount ?? this.stargazersCount,
      language: language ?? this.language,
    );
  }
}
