import 'package:flutter_modular/flutter_modular.dart';
import 'search_bloc.dart';
import 'search_page.dart';
import 'search_repository.dart';
import '../../shared/utils/api_service.dart';

class SearchModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => ApiService('https://api.github.com')),
    Bind.singleton((i) => SearchRepository(i.get<ApiService>())),
    Bind.singleton((i) => SearchBloc(i.get<SearchRepository>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => SearchPage(bloc: Modular.get())),
  ];
}
