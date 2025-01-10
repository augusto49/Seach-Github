import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_bloc.dart';
import '../../shared/widgets/user_card.dart';

class SearchPage extends StatefulWidget {
  final SearchBloc bloc;

  const SearchPage({Key? key, required this.bloc}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearchActive = false;
  List<String> _searchHistory = [];
  FocusNode _searchFocus = FocusNode();
  List<String> _filteredSearchHistory = [];


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadSearchHistory();
    _searchFocus.addListener(_handleSearchFocusChange);
  }
  void _handleSearchFocusChange(){
    if(!_searchFocus.hasFocus){
      setState(() {
        _filteredSearchHistory = [];
      });
    }else{
      _loadSearchHistory();
    }
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
        _filteredSearchHistory = _searchHistory;
    });
  }


  Future<void> _saveSearchHistory(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('searchHistory') ?? [];
    history.remove(query);
    history.insert(0, query);

    if(history.length > 5){
      history = history.sublist(0,5);
    }

    await prefs.setStringList('searchHistory', history);
    setState(() {
      _searchHistory = history;
      _filteredSearchHistory = _searchHistory;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !widget.bloc.state.isLoading &&
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
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Search ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text: 'd_evs',
                          style: TextStyle(color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    focusNode: _searchFocus,
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                                _filteredSearchHistory = [];
                            });
                          },
                        ) : null,
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor, insira um usuário';
                      }
                      return null;
                    },
                    onChanged: (value) {
                       setState(() {
                         _filteredSearchHistory = _searchHistory.where((element) => element.toLowerCase().startsWith(value.toLowerCase())).toList();
                       });
                    },
                    onFieldSubmitted: (_) => _onSearch(),
                  ),
                ),
                if(_searchFocus.hasFocus && _filteredSearchHistory.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredSearchHistory.length,
                        itemBuilder: (context, index){
                          final suggestion = _filteredSearchHistory[index];
                          return ListTile(
                            title: Text(suggestion),
                            onTap: (){
                              _onSuggestionSelected(suggestion);
                            },
                          );
                        }
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 130,
                      child: ElevatedButton(
                        onPressed: _onSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        child: const Text('Buscar',
                          style: TextStyle(color: Colors.white),
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
                        if (state.isLoading && state.users.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state.users.isEmpty) {
                          return const Center(child: Text('Nenhum usuário encontrado.'));
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: state.hasMore ? state.users.length + 1 : state.users.length,
                          itemBuilder: (context, index) {
                            if (index >= state.users.length) {
                              return const Center(child: CircularProgressIndicator());
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