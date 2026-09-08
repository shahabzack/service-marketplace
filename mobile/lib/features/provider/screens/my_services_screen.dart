import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/service_model.dart';
import '../services/provider_service.dart';

final providerServiceProvider = Provider<ProviderService>((ref) {
  return ProviderService();
});

final myServicesProvider = FutureProvider.autoDispose<List<ServiceModel>>((
  ref,
) async {
  final service = ref.read(providerServiceProvider);
  return service.getMyServices();
});

class MyServicesScreen extends ConsumerWidget {
  const MyServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(myServicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Services'), centerTitle: true),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Unable to load services.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(myServicesProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (services) {
          if (services.isEmpty) {
            return const Center(
              child: Text(
                'No services yet.\nAdd your first service.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myServicesProvider);
              await ref.read(myServicesProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final service = services[index];

                return Card(
                  child: ListTile(
                    title: Text(service.title),
                    subtitle: Text(
                      '${service.category}\n₹${service.price.toStringAsFixed(2)}',
                    ),
                    isThreeLine: true,
                    trailing: Icon(
                      service.isActive
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
