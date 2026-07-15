import 'package:flutter/material.dart';

import '../../../app/theme/sagres_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      key: const Key('profile-screen'),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: SagresColors.yellow.withValues(alpha: .3),
              foregroundColor: SagresColors.red,
              child: const Icon(Icons.person),
            ),
            const SizedBox(width: 10),
            Text(
              'Você',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [SagresColors.red, SagresColors.orange],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: SagresColors.yellow,
                foregroundColor: SagresColors.deepRed,
                child: Icon(Icons.person_outline, size: 38),
              ),
              SizedBox(height: 12),
              Text(
                'Ouvinte Sagres',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Perfil demonstrativo da POC',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ...const [
          (Icons.favorite_outline, 'Favoritos'),
          (Icons.download_outlined, 'Downloads'),
          (Icons.notifications_outlined, 'Notificações'),
          (Icons.settings_outlined, 'Configurações'),
        ].map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Card(
              child: ListTile(
                leading: Icon(item.$1, color: SagresColors.red),
                title: Text(
                  item.$2,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: const Icon(Icons.lock_outline, size: 17),
                subtitle: const Text('Fora do escopo desta POC'),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
