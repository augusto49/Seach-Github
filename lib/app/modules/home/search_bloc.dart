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
  final bool isLoadingMore;
  final bool hasMore;

  SearchState({
    required this.users,
    required this.isLoading,
    this.isLoadingMore = false,
    this.hasMore = true,
  });
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;
  int _currentPage = 1;
  final int _perPage = 20;

  SearchBloc(this.repository)
      : super(SearchState(users: [], isLoading: false)) {
    on<SearchEvent>((event, emit) async {
      if (!event.loadMore) {
        _currentPage = 1;
        emit(SearchState(users: [], isLoading: true));
      } else {
        if (state.isLoadingMore || !state.hasMore) return;
        emit(SearchState(
            users: state.users,
            isLoading: state.isLoading,
            isLoadingMore: true,
            hasMore: state.hasMore));
      }

      try {
        final users = await repository.searchUsers(event.query,
            page: _currentPage, perPage: _perPage);
        _currentPage++;

        emit(SearchState(
          users: event.loadMore ? [...state.users, ...users] : users,
          isLoading: false,
          isLoadingMore: false,
          hasMore: users.length == _perPage,
        ));
      } catch (_) {
        emit(SearchState(
            users: state.users,
            isLoading: false,
            isLoadingMore: false,
            hasMore: false));
      }
    });
  }
}
