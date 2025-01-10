import 'package:flutter/material.dart';
import '../../shared/models/repo_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/utils/git_service.dart';
import '../../shared/widgets/repo_card.dart';
import '../../shared/widgets/user_info_card.dart';


class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfileModel? _userData;
  List<RepoModel> _repositories = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _perPage = 10;
  bool _hasMore = true;
  String _sortOption = 'full_name';
  final ScrollController _scrollController = ScrollController();
  final GithubService _githubService = GithubService();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          _hasMore &&
          !_isLoadingMore) {
        _fetchRepositories();
      }
    });
  }

  Future<void> _fetchData() async {
    try {
      _userData = await _githubService.fetchUserProfile(widget.username);
      await _fetchRepositories();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _showError('Erro ao buscar dados: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchRepositories() async {
    if (!_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      List<RepoModel> newRepositories = await _githubService.fetchRepositories(
          widget.username, _currentPage, _perPage, _sortOption);

      setState(() {
        _repositories.addAll(newRepositories);
        _currentPage++;
        _hasMore = newRepositories.length == _perPage;
      });
    } catch (e) {
      _showError('Erro ao buscar repositórios: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _handleSortChanged(String? value) {
    if (value != null) {
      setState(() {
        _sortOption = value;
        _repositories.clear();
        _currentPage = 1;
        _isLoadingMore = false;
        _hasMore = true;
      });
      _fetchRepositories();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

 @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;


    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
          ? const Center(child: Text('Erro ao carregar os dados do usuário.'))
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? size.width * 0.05 : 10,
                  vertical: 10,
                ),
                  child: isLargeScreen
                     ? _buildLargeScreenLayout(context)
                      : _buildMobileLayout(context)
             ),
           ),
    );
  }
   Widget _buildLargeScreenLayout(BuildContext context) {
    return  Row(
            children: [
              Flexible(
                 flex: 1,
                  child:  _userData != null
                       ? Padding(
                          padding: const EdgeInsets.all(8.0),
                            child: UserInfoCard(userData: _userData!),
                           )
                        : const SizedBox(),
                ),
                 Flexible(
                    flex: 2,
                     child: _buildRepoList(context),
                  ),
              ],
             );
   }

    Widget _buildMobileLayout(BuildContext context) {
     return  Column(
                  children: [
                     if(_userData != null) UserInfoCard(userData: _userData!),
                    Expanded(
                      child: _buildRepoList(context),
                    ),
                  ],
             );
   }
    Widget _buildRepoList(BuildContext context) {
       return  Column(
                      children: [
                            if(_repositories.isNotEmpty)  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                               child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                 const Text('Ordenar por: '),
                                 DropdownButton<String>(
                                    value: _sortOption,
                                   onChanged: _handleSortChanged,
                                   items: const [
                                    DropdownMenuItem(
                                       value: 'full_name',
                                      child: Text('Nome'),
                                     ),
                                     DropdownMenuItem(
                                       value: 'created',
                                      child: Text('Criação'),
                                    ),
                                     DropdownMenuItem(
                                      value: 'updated',
                                     child: Text('Atualização'),
                                  ),
                                     DropdownMenuItem(
                                       value: 'pushed',
                                      child: Text('Envio'),
                                   ),
                                 ],
                                ),
                             ],
                            ),
                           ),
                         Expanded(
                           child:  ListView.builder(
                                    controller: _scrollController,
                                      padding:  const EdgeInsets.all(16.0),
                                        itemCount: _repositories.length + (_isLoadingMore ? 1 : 0) ,
                                            itemBuilder: (context, index) {
                                            if (index < _repositories.length) {
                                                  return RepoCard(repo: _repositories[index]);
                                                } else {
                                                  return _isLoadingMore ? const Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                                    child: Center(child: CircularProgressIndicator()),
                                                )
                                                   : (_hasMore || _repositories.isEmpty ? const SizedBox()  : const Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                                       child: Center(
                                                         child: Text(
                                                            'Todos os repositórios foram carregados.'),
                                                     ),
                                                  ));
                                            }
                                      },
                             ),
                          ),
                        ],
                      );
   }
}