import 'package:flutter/material.dart';
import '../../modules/webview/webview_page.dart';
import '../models/repo_model.dart';
import '../utils/date_formatter.dart';

class RepoCard extends StatelessWidget {
  final RepoModel repo;

  const RepoCard({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(
                    url: repo.htmlUrl ?? '',
                    title: repo.name ?? 'Repositório',
                  ),
                ),
              );
            },
            child: Text(
              repo.name ?? 'Sem nome',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (repo.description != null) Text(repo.description!, style: const TextStyle(color: Colors.black),),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star_border, size: 25, color:  Color.fromARGB(255, 87, 82, 82)),
                  const SizedBox(width: 4),
                  Text('${repo.stargazersCount}', style: const TextStyle(color:  Color.fromARGB(255, 87, 82, 82)),),
                  const SizedBox(width: 16),
                  const Icon(Icons.update, size: 16, color:  Color.fromARGB(255, 87, 82, 82)),
                  const SizedBox(width: 4),
                  Text(DateFormatter.format(repo.updatedAt ?? ''), style: const TextStyle(color:  Color.fromARGB(255, 87, 82, 82)),),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
        )
      ],
    );
  }
}