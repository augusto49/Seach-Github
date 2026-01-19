import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'custom_widgets.dart';

class UserInfoCard extends StatelessWidget {
  final UserProfileModel userData;

  const UserInfoCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.purple, width: 2),
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(userData.avatarUrl!),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.name ?? 'Nome não disponível',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${userData.username}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _buildStatItem(Icons.people, '${userData.followers} seguidores'),
              _buildStatItem(Icons.favorite, '${userData.following} seguindo'),
            ],
          ),
          if (userData.bio != null) ...[
            const SizedBox(height: 20),
            Text(
              userData.bio!,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.grey.shade800,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            children: [
              if (userData.company != null)
                buildInfoRow(Icons.business, userData.company!),
              if (userData.location != null)
                buildInfoRow(
                  Icons.location_on,
                  userData.location?.split(',').first ?? userData.location!,
                ),
              if (userData.email != null)
                buildLinkInfo(context, 'email', userData.email!,
                    'mailto:${userData.email}'),
              if (userData.blog != null && userData.blog!.isNotEmpty)
                buildLinkInfo(context, 'link', 'Website', userData.blog!),
              if (userData.twitterUsername != null)
                buildLinkInfo(
                  context,
                  'flutter_dash', // Using a generic icon if twitter not avail, or mapped in helper
                  '@${userData.twitterUsername}',
                  'https://twitter.com/${userData.twitterUsername}',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.purple),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
