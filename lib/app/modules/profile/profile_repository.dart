import '../../shared/models/repo_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/utils/api_service.dart';

class ProfileRepository {
  final ApiService apiService;

  ProfileRepository(this.apiService);

  Future<UserProfileModel> fetchUserProfile(String username) async {
    try {
      final response = await apiService.get('/users/$username');
      return UserProfileModel.fromJson(response, username);
    } catch (e) {
      throw Exception('Erro ao buscar dados do usuário: $e');
    }
  }

  Future<List<RepoModel>> fetchRepositories(
      String username, int page, int perPage, String sortOption) async {
    try {
      final response = await apiService.get(
          '/users/$username/repos?page=$page&per_page=$perPage&sort=$sortOption');
      final List<dynamic> repoList = response;
      return repoList.map((repo) => RepoModel.fromJson(repo)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar repositórios: $e');
    }
  }
}
