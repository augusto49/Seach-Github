import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/repo_model.dart';


class GithubService {
  final http.Client _client = http.Client();

  Future<UserProfileModel> fetchUserProfile(String username) async {
    final userUrl = 'https://api.github.com/users/$username';
    final response = await _client.get(Uri.parse(userUrl));

    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(json.decode(response.body), username);
    } else {
      throw Exception('Erro ao buscar dados do usuário.');
    }
  }

  Future<List<RepoModel>> fetchRepositories(
      String username, int page, int perPage, String sortOption) async {
    final repoUrl =
        'https://api.github.com/users/$username/repos?page=$page&per_page=$perPage&sort=$sortOption';
    final response = await _client.get(Uri.parse(repoUrl));

    if (response.statusCode == 200) {
      List<dynamic> repoList = json.decode(response.body);
      return repoList.map((repo) => RepoModel.fromJson(repo)).toList();
    } else {
      throw Exception('Erro ao buscar repositórios.');
    }
  }
}