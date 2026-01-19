import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:petize/app/modules/profile/profile_bloc.dart';
import '../../shared/widgets/repo_card.dart';
import '../../shared/widgets/user_info_card.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileBloc bloc = Modular.get<ProfileBloc>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc.add(FetchProfileData(widget.username));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        bloc.state.hasMore &&
        !bloc.state.isLoadingMore) {
      bloc.add(FetchMoreRepositories());
    }
  }

  void _handleSortChanged(String? value) {
    if (value != null) {
      bloc.add(ChangeSortOption(value));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.userData == null
                  ? const Center(
                      child: Text('Erro ao carregar os dados do usuário.'))
                  : SafeArea(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isLargeScreen ? size.width * 0.05 : 10,
                            vertical: 10,
                          ),
                          child: isLargeScreen
                              ? _buildLargeScreenLayout(context, state)
                              : _buildMobileLayout(context, state)),
                    ),
        );
      },
    );
  }

  Widget _buildLargeScreenLayout(BuildContext context, ProfileState state) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: state.userData != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UserInfoCard(userData: state.userData!),
                )
              : const SizedBox(),
        ),
        Flexible(
          flex: 2,
          child: _buildRepoList(context, state),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, ProfileState state) {
    return Column(
      children: [
        if (state.userData != null) UserInfoCard(userData: state.userData!),
        Expanded(
          child: _buildRepoList(context, state),
        ),
      ],
    );
  }

  Widget _buildRepoList(BuildContext context, ProfileState state) {
    return Column(
      children: [
        if (state.repositories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Ordenar por: '),
                DropdownButton<String>(
                  value: state.sortOption,
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
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount:
                state.repositories.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.repositories.length) {
                return RepoCard(repo: state.repositories[index]);
              } else {
                return state.isLoadingMore
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : (state.hasMore || state.repositories.isEmpty
                        ? const SizedBox()
                        : const Padding(
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
