import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../../provider/screens/provider_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final isApprovedProvider = user?.isApprovedProvider ?? false;

    void openProviderMode() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const ProviderHomeScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isApprovedProvider ? 'Customer Mode' : 'Service Marketplace',
        ),
        centerTitle: true,
        actions: [
          if (isApprovedProvider)
            IconButton(
              onPressed: openProviderMode,
              icon: const Icon(Icons.business_center_outlined),
              tooltip: 'Provider Mode',
            ),
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
              'Welcome${user != null ? ', ${user.name}' : ''} 👋',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Find trusted services near you.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            if (isApprovedProvider) ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.business_center_outlined),
                  title: const Text('Provider Mode'),
                  subtitle: const Text('You are an approved service provider.'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: openProviderMode,
                ),
              ),
              const SizedBox(height: 12),
            ],

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
