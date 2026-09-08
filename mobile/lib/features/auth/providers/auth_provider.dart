import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_models.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? accessToken;
  final String? errorMessage;
  final UserModel? user;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.accessToken,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? accessToken,
    String? errorMessage,
    UserModel? user,
    bool clearErrorMessage = false,
    bool clearAccessToken = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: clearAccessToken ? null : accessToken ?? this.accessToken,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      user: clearUser ? null : user ?? this.user,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }

  Future<void> restoreSession() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final authService = ref.read(authServiceProvider);

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final token = await tokenStorage.getAccessToken();

      if (token == null || token.isEmpty) {
        state = const AuthState();
        return;
      }

      final user = await authService.getCurrentUser(token);

      state = AuthState(isAuthenticated: true, accessToken: token, user: user);
    } catch (e) {
      await tokenStorage.deleteAccessToken();

      state = const AuthState();
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final authService = ref.read(authServiceProvider);
      final tokenStorage = ref.read(tokenStorageProvider);

      final response = await authService.login(
        email: email,
        password: password,
      );

      await tokenStorage.saveAccessToken(response.accessToken);

      final user = await authService.getCurrentUser(response.accessToken);

      state = AuthState(
        isAuthenticated: true,
        accessToken: response.accessToken,
        user: user,
      );
    } on DioException catch (e) {
      String message = 'Unable to login. Please try again.';

      if (e.response?.statusCode == 401) {
        message = 'Invalid email or password';
      } else if (e.response?.statusCode == 400) {
        message = 'Invalid request. Please check your details.';
      } else if (e.response?.statusCode == 500) {
        message = 'Server error. Please try again later.';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Unable to connect to the server.';
      }

      state = AuthState(errorMessage: message);
    } catch (e) {
      state = const AuthState(
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> logout() async {
    final tokenStorage = ref.read(tokenStorageProvider);

    await tokenStorage.deleteAccessToken();

    state = const AuthState();
  }
}
