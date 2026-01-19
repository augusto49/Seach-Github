import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/models/repo_model.dart';
import '../../shared/models/user_model.dart';
import 'profile_repository.dart';

// Events
abstract class ProfileEvent {}

class FetchProfileData extends ProfileEvent {
  final String username;
  FetchProfileData(this.username);
}

class FetchMoreRepositories extends ProfileEvent {}

class ChangeSortOption extends ProfileEvent {
  final String sortOption;
  ChangeSortOption(this.sortOption);
}

// States
class ProfileState {
  final UserProfileModel? userData;
  final List<RepoModel> repositories;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String sortOption;
  final String? error;

  ProfileState({
    this.userData,
    this.repositories = const [],
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.sortOption = 'full_name',
    this.error,
  });

  ProfileState copyWith({
    UserProfileModel? userData,
    List<RepoModel>? repositories,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? sortOption,
    String? error,
  }) {
    return ProfileState(
      userData: userData ?? this.userData,
      repositories: repositories ?? this.repositories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      sortOption: sortOption ?? this.sortOption,
      error: error,
    );
  }
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  late String _username;
  final int _perPage = 10;

  ProfileBloc(this.repository) : super(ProfileState()) {
    on<FetchProfileData>(_onFetchProfileData);
    on<FetchMoreRepositories>(_onFetchMoreRepositories);
    on<ChangeSortOption>(_onChangeSortOption);
  }

  Future<void> _onFetchProfileData(
      FetchProfileData event, Emitter<ProfileState> emit) async {
    _username = event.username;
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final user = await repository.fetchUserProfile(_username);
      final repos = await repository.fetchRepositories(
          _username, 1, _perPage, state.sortOption);

      emit(state.copyWith(
        userData: user,
        repositories: repos,
        isLoading: false,
        currentPage: 2,
        hasMore: repos.length == _perPage,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchMoreRepositories(
      FetchMoreRepositories event, Emitter<ProfileState> emit) async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final newRepos = await repository.fetchRepositories(
          _username, state.currentPage, _perPage, state.sortOption);

      emit(state.copyWith(
        repositories: [...state.repositories, ...newRepos],
        isLoadingMore: false,
        currentPage: state.currentPage + 1,
        hasMore: newRepos.length == _perPage,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }

  Future<void> _onChangeSortOption(
      ChangeSortOption event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(
        sortOption: event.sortOption,
        repositories: [],
        isLoadingMore: true,
        currentPage: 1,
        hasMore: true));

    try {
      final repos = await repository.fetchRepositories(
          _username, 1, _perPage, event.sortOption);

      emit(state.copyWith(
        repositories: repos,
        isLoadingMore: false,
        currentPage: 2,
        hasMore: repos.length == _perPage,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }
}
