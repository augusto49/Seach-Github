import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_bloc.dart';
import '../../shared/widgets/user_card.dart';
import '../../shared/widgets/skeleton_user_card.dart';

class SearchPage extends StatefulWidget {
  final SearchBloc bloc;

  const SearchPage({super.key, required this.bloc});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearchActive = false;
  List<String> _searchHistory = [];
  final FocusNode _searchFocus = FocusNode();
  List<String> _filteredSearchHistory = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadSearchHistory();
    _searchFocus.addListener(_handleSearchFocusChange);
  }

  void _handleSearchFocusChange() {
    if (!_searchFocus.hasFocus) {
      setState(() {
        _filteredSearchHistory = [];
      });
    } else {
      _loadSearchHistory();
    }
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('searchHistory') ?? [];
    history.remove(query);
    history.insert(0, query);

    if (history.length > 5) {
      history = history.sublist(0, 5);
    }

    await prefs.setStringList('searchHistory', history);
    setState(() {
      _searchHistory = history;
      // Do not update _filteredSearchHistory here to avoid showing it immediately
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !widget.bloc.state.isLoading &&
        !widget.bloc.state.isLoadingMore &&
        widget.bloc.state.hasMore) {
      widget.bloc.add(SearchEvent(_searchController.text, loadMore: true));
    }
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    setState(() {
      _isSearchActive = true;
    });
    _saveSearchHistory(_searchController.text);
    widget.bloc.add(SearchEvent(_searchController.text));
  }

  void _onSuggestionSelected(String suggestion) {
    setState(() {
      _searchController.text = suggestion;
      _filteredSearchHistory = [];
    });
    _onSearch();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? size.width * 0.1 : 10,
            vertical: 10,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_isSearchActive) const Spacer(flex: 1),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          letterSpacing: 1.2,
                        ),
                        children: [
                          TextSpan(
                            text: 'Search ',
                            style: TextStyle(color: Color(0xFF2196F3)),
                          ),
                          TextSpan(
                            text: 'd_evs',
                            style: TextStyle(color: Color(0xFF9C27B0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    focusNode: _searchFocus,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _filteredSearchHistory = [];
                                });
                              },
                            )
                          : null,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira um usuário';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _filteredSearchHistory = [];
                        } else {
                          _filteredSearchHistory = _searchHistory
                              .where((element) => element
                                  .toLowerCase()
                                  .startsWith(value.toLowerCase()))
                              .toList();
                        }
                      });
                    },
                    onFieldSubmitted: (_) => _onSearch(),
                  ),
                ),
                if (_searchFocus.hasFocus && _filteredSearchHistory.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredSearchHistory.length,
                        itemBuilder: (context, index) {
                          final suggestion = _filteredSearchHistory[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _onSuggestionSelected(suggestion);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.history,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Text(
                                        suggestion,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.north_west,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7B1FA2).withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _onSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Buscar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (!_isSearchActive) const Spacer(flex: 1),
                if (_isSearchActive)
                  Expanded(
                    child: BlocBuilder<SearchBloc, SearchState>(
                      bloc: widget.bloc,
                      builder: (context, state) {
                        if (state.isLoading) {
                          return ListView.builder(
                            itemCount: 10,
                            itemBuilder: (_, __) => const SkeletonUserCard(),
                          );
                        }
                        if (state.users.isEmpty) {
                          return const Center(
                              child: Text('Nenhum usuário encontrado.'));
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: state.hasMore
                              ? state.users.length + 1
                              : state.users.length,
                          itemBuilder: (context, index) {
                            if (index >= state.users.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            final user = state.users[index];
                            return UserCard(user: user);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
