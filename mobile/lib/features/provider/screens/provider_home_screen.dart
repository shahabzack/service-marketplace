import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import 'my_services_screen.dart';

class ProviderHomeScreen extends ConsumerWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Mode'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user?.name ?? 'Provider'} 👋',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your services and bookings.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),

              _ProviderCard(
                icon: Icons.home_repair_service_outlined,
                title: 'My Services',
                subtitle: 'Create and manage your services.',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MyServicesScreen()),
                  );
                },
              ),

              const SizedBox(height: 12),

              _ProviderCard(
                icon: Icons.calendar_month_outlined,
                title: 'Booking Requests',
                subtitle: 'View and manage customer requests.',
                onTap: () {},
              ),

              const SizedBox(height: 12),

              _ProviderCard(
                icon: Icons.schedule_outlined,
                title: 'Availability',
                subtitle: 'Set your working days and hours.',
                onTap: () {},
              ),

              const SizedBox(height: 12),

              _ProviderCard(
                icon: Icons.person_outline,
                title: 'Provider Profile',
                subtitle: 'Manage your provider information.',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProviderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
