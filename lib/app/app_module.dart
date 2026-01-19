import 'package:flutter_modular/flutter_modular.dart';
import 'package:search_github/app/modules/profile/profile_page.dart';
import 'package:search_github/app/modules/profile/profile_repository.dart';
import 'package:search_github/app/modules/profile/profile_bloc.dart';
import 'modules/home/search_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ProfileRepository(i.get())),
    Bind.lazySingleton((i) => ProfileBloc(i.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: SearchModule()),
    ChildRoute('/profile',
        child: (_, args) => ProfilePage(username: args.data)),
  ];
}
