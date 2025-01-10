import '../../shared/models/user_model.dart';
import '../../shared/utils/api_service.dart';

class SearchRepository {
  final ApiService apiService;

  SearchRepository(this.apiService);

  Future<List<UserModel>> searchUsers(String query, {int page = 1}) async {
  final results = await apiService.get('/search/users?q=$query&page=$page');
  return results.map((user) => UserModel.fromJson(user)).toList();
  }
}
