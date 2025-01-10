import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/models/user_model.dart';
import 'search_repository.dart';

class SearchEvent {
  final String query;
  final bool loadMore;

  SearchEvent(this.query, {this.loadMore = false});
}

class SearchState {
  final List<UserModel> users;
  final bool isLoading;
  final bool hasMore;

  SearchState({required this.users, required this.isLoading, this.hasMore = true});
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;
  int _currentPage = 1;

  SearchBloc(this.repository)
      : super(SearchState(users: [], isLoading: false)) {
    on<SearchEvent>((event, emit) async {
      if (!event.loadMore) {
        _currentPage = 1; // Reseta a paginação ao fazer uma nova busca
        emit(SearchState(users: [], isLoading: true));
      } else {
        emit(SearchState(users: state.users, isLoading: true, hasMore: state.hasMore));
      }

      try {
        final users = await repository.searchUsers(event.query, page: _currentPage);
        _currentPage++;
        emit(SearchState(
          users: event.loadMore ? [...state.users, ...users] : users,
          isLoading: false,
          hasMore: users.isNotEmpty,
        ));
      } catch (_) {
        emit(SearchState(users: state.users, isLoading: false, hasMore: false));
      }
    });
  }
}
