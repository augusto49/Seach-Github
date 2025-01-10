class UserDetailModel {
  final String login;
  final String avatarUrl;
  final String name;
  final String bio;
  final String htmlUrl;
  final int publicRepos;
  final int followers;
  final int following;

  UserDetailModel({
    required this.login,
    required this.avatarUrl,
    required this.name,
    required this.bio,
    required this.htmlUrl,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      login: json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      name: json['name'] ?? 'No name provided',
      bio: json['bio'] ?? 'No bio available',
      htmlUrl: json['html_url'] ?? '',
      publicRepos: json['public_repos'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }
}
