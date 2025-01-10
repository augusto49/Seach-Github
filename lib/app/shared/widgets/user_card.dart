import 'package:flutter/material.dart';
import '../../shared/models/user_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          Modular.to.pushNamed('/profile', arguments: user.login);
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          title: Text(user.login, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
            user.htmlUrl,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
           trailing: const Icon(Icons.open_in_new),
        ),
      ),
    );
  }
}