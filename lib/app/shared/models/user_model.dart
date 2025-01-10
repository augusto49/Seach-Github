class UserModel {
  final String login;
  final String avatarUrl;
  final String htmlUrl;

  UserModel({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
    );
  }
}

//Profile
class UserProfileModel {
  final String? name;
  final String? username;
  final String? avatarUrl;
  final int? followers;
  final int? following;
  final String? bio;
  final String? company;
  final String? location;
  final String? email;
  final String? blog;
  final String? twitterUsername;

  UserProfileModel({
    this.name,
    this.username,
    this.avatarUrl,
    this.followers,
    this.following,
    this.bio,
    this.company,
    this.location,
    this.email,
    this.blog,
    this.twitterUsername,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json, String username) {
    return UserProfileModel(
      name: json['name'],
      username: username,
      avatarUrl: json['avatar_url'],
      followers: json['followers'],
      following: json['following'],
      bio: json['bio'],
      company: json['company'],
      location: json['location'],
      email: json['email'],
      blog: json['blog'],
      twitterUsername: json['twitter_username'],
    );
  }
}