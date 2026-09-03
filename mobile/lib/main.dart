import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: ServiceMarketplaceApp()));
}

class ServiceMarketplaceApp extends ConsumerStatefulWidget {
  const ServiceMarketplaceApp({super.key});

  @override
  ConsumerState<ServiceMarketplaceApp> createState() =>
      _ServiceMarketplaceAppState();
}

class _ServiceMarketplaceAppState extends ConsumerState<ServiceMarketplaceApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(authProvider.notifier).restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Service Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: authState.isAuthenticated
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
