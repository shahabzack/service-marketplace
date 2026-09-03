import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Marketplace'),
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome 👋',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Find trusted services near you.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Find a Service'),
                subtitle: const Text('Discover services for your needs'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('My Bookings'),
                subtitle: const Text('View your upcoming bookings'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('My Profile'),
                subtitle: const Text('Manage your account'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
