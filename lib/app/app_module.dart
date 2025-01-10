import 'package:flutter_modular/flutter_modular.dart';
import 'package:petize/app/modules/profile/profile_page.dart';
import 'modules/home/search_module.dart';

class AppModule extends Module {
  @override
  final List<Module> imports = [];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: SearchModule()),
    ChildRoute('/profile',
            child: (_, args) => ProfilePage(username: args.data)),
  ];
}
