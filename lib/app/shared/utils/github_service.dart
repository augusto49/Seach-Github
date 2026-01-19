import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:search_github/app/shared/models/repo_model.dart';
import 'package:search_github/app/shared/models/user_model.dart';

class GithubService {
  final http.Client client;

  GithubService({http.Client? client}) : client = client ?? http.Client();

  Future<UserProfileModel> fetchUserProfile(String username) async {
    final response =
        await client.get(Uri.parse('https://api.github.com/users/$username'));

    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(json.decode(response.body), username);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<List<RepoModel>> fetchRepositories(
      String username, int page, int perPage, String sortOption) async {
    final response = await client.get(Uri.parse(
        'https://api.github.com/users/$username/repos?page=$page&per_page=$perPage&sort=$sortOption'));

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((item) => RepoModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch repositories');
    }
  }
}
