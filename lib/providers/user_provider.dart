import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/models/User.dart';
import 'package:my_app/repositories/auth_repository.dart';
import 'package:my_app/responses/UpdateUserResponse.dart'
    as update_user_response;
import 'package:my_app/services/AuthService.dart';

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Notifier to manage User state
class UserStateNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;
  final Ref _ref;
  UserStateNotifier(this._authService, this._ref)
      : super(const AsyncValue.data(null)) {
    fetchUser();
  }

  // Fetch user data
  Future<void> fetchUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.fetchUser();
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<update_user_response.UpdateUserResponse> updateuser({
    String? name,
    String? email,
    String? password,
    String? gender,
    String? phone,
    String? address,
    String? password_confirmation,
    File? image,
  }) async {
    state = const AsyncValue.loading();
    try {
      final updateResponse = await _authService.updateuser(
        name: name,
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        gender: gender,
        phone: phone,
        address: address,
        image: image,
      );
      final updatedUser = await _authService.fetchUser();
      state = AsyncValue.data(updatedUser);
      return updateResponse;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  // Clear user data (e.g., on logout)
  void clearUser() {
    state = const AsyncValue.data(null);
  }

  Future<void> logout(BuildContext context) async {
    state = const AsyncValue.loading();
    try {
      final authRepository = _ref.read(authRepositoryProvider);
      await authRepository.logout();
      state = const AsyncValue.data(null);
      _ref.read(authStateProvider.notifier).state = false;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}

// Provider for UserStateNotifier
final userProvider =
    StateNotifierProvider<UserStateNotifier, AsyncValue<User?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return UserStateNotifier(authService, ref);
});

// Provider to check if user is logged in
final userLoggedInProvider = FutureProvider<bool>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return await authRepo.isUserLoggedIn();
});

// Example StateProvider to hold authentication state (logged in or not)
final authStateProvider = StateProvider<bool>((ref) => false);
