class RepoModel {
  final String? name;
  final String? description;
  final String? htmlUrl;
  final int? stargazersCount;
  final String? updatedAt;

  RepoModel({
    this.name,
    this.description,
    this.htmlUrl,
    this.stargazersCount,
    this.updatedAt,
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      name: json['name'],
      description: json['description'],
      htmlUrl: json['html_url'],
      stargazersCount: json['stargazers_count'],
      updatedAt: json['updated_at'],
    );
  }
}