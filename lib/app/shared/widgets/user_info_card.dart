import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'custom_widgets.dart';

class UserInfoCard extends StatelessWidget {
  final UserProfileModel userData;

  const UserInfoCard({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple[50],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(userData.avatarUrl!),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData.name ?? 'Nome não disponível',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    '@${userData.username}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.people_outline_sharp,
                  color: Color.fromARGB(255, 87, 82, 82)),
              const SizedBox(width: 4),
              Text(
                '${userData.followers} seguidores',
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 87, 82, 82)),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.favorite_border,
                  color: Color.fromARGB(255, 87, 82, 82)),
              const SizedBox(width: 4),
              Text(
                '${userData.following} seguindo',
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 87, 82, 82)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (userData.bio != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                userData.bio!,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontStyle: FontStyle.normal, color: Colors.black),
              ),
            ),
          Wrap(
            spacing: 10.0,
            children: [
              if (userData.company != null)
                buildInfoRow(Icons.work_outline, ' ${userData.company}'),
              if (userData.location != null)
                buildInfoRow(
                  Icons.location_on_outlined,
                  '${userData.location?.split(',').first ?? userData.location}',
                ),
            ],
          ),
          Wrap(
            spacing: 10.0,
            children: [
              if (userData.email != null)
                buildLinkInfo(context, 'email', userData.email!,
                    'mailto:${userData.email}'),
              if (userData.blog != null && userData.blog!.isNotEmpty)
                buildLinkInfo(context, 'site', userData.blog!, userData.blog!),
              if (userData.twitterUsername != null)
                buildLinkInfo(
                  context,
                  'twitter',
                  '@${userData.twitterUsername}',
                  'https://twitter.com/${userData.twitterUsername}',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
