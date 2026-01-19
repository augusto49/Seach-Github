import '../../shared/models/user_model.dart';
import '../../shared/utils/api_service.dart';

class SearchRepository {
  final ApiService apiService;

  SearchRepository(this.apiService);

  Future<List<UserModel>> searchUsers(String query,
      {int page = 1, int perPage = 20}) async {
    final response = await apiService
        .get('/search/users?q=$query&page=$page&per_page=$perPage');
    final List<dynamic> results = response['items'];
    return results.map((user) => UserModel.fromJson(user)).toList();
  }
}
