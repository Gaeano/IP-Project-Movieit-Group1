import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:movieit/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  late final StreamSubscription<AuthState> _authSubscription;

  Session? _session;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
      _session = _authService.currentSession;
    _authSubscription = _authService.onAuthStateChange.listen((data) {
      _session = data.session;
      notifyListeners();
    });
  }

  Session? get session => _session;
  User? get user => _session?.user;
  bool get isAuthenticated => _session != null;
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
      _session = response.session;
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
      _session = response.session;
      if (response.session != null) {
        return SignUpResult.authenticated;
      }
      if (response.user?.identities?.isEmpty ?? false){
        _errorMessage = 'An account with this email already exists. Please log in instead.';
        return SignUpResult.failed;
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
      _session = null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> resendConfirmationEmail(String email) async {
    try{
      await _authService.resendConfirmationEmail(email);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Failed to resend confirmation email. Please try again.';
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