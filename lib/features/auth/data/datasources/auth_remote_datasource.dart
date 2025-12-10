import 'dart:async';

import 'package:travafa/core/error/exception.dart';


import 'package:travafa/features/auth/data/model/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Fake backend database
  final List<Map<String, String>> _fakeUsersDb = [];

  /// Fake session
  Map<String, String>? _currentUser;

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate loading

      final exists = _fakeUsersDb.any((u) => u['email'] == email);
      if (exists) {
        throw const ServerException("Email already registered");
      }

      final newUser = {
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "name": name,
        "email": email,
        "password": password,
      };

      _fakeUsersDb.add(newUser);
      _currentUser = newUser;
      print(newUser);

      return UserModel(
        id: newUser['id']!,
        name: newUser['name']!,
        email: newUser['email']!,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException("Signup failed: $e");
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate delay

      final matchingUser = _fakeUsersDb.firstWhere(
        (u) => u['email'] == email,
        orElse: () => throw const ServerException("User not found"),
      );

      if (matchingUser['password'] != password) {
        throw const ServerException("Incorrect password");
      }

      _currentUser = matchingUser;

      return UserModel(
        id: matchingUser['id']!,
        name: matchingUser['name']!,
        email: matchingUser['email']!,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException("Login failed: $e");
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      if (_currentUser == null) return null;

      return UserModel(
        id: _currentUser!['id']!,
        name: _currentUser!['name']!,
        email: _currentUser!['email']!,
      );
    } catch (e) {
      throw ServerException("Failed to load user: $e");
    }
  }
}
