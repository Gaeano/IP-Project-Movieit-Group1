import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:movieit/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  late final StreamSubscription<AuthState> _authSubscription;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _user = _authService.currentUser;
    _authSubscription = _authService.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get accessToken => _authService.accessToken;

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );
      _user = response.user;
      return response.session != null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      _user = response.user;
      if (response.session != null) {
        return SignUpResult.authenticated;
      }
      return SignUpResult.needsEmailConfirmation;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return SignUpResult.failed;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return SignUpResult.failed;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signInWithGoogle();
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Google sign-in failed. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signOut();
      _user = null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}

enum SignUpResult { authenticated, needsEmailConfirmation, failed }