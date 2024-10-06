import 'package:comments_app/services/firebase/firestore/user_data_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase/firebase_auth_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final UserService _userService = UserService();
  User? _user;
  bool _isLoading = true;
  String _errorMessage = "";

  String _email = "";
  String _password = "";
  String _name = "";
  bool _isSignup = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSignup => _isSignup;
  String get email => _email;
  String get password => _password;
  String get name => _name;
  String get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _user = _authService.currentUser();
    _isLoading = false;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void toggleRegister() {
    _isSignup = !_isSignup;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _user = await _authService.loginWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? e.code;
      rethrow ;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signin(String email, String password) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _user = await _authService.createWithEmail(email, password);
      if (user != null) {
        await _userService.saveUserData(_user!.uid, name, email);
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? e.code;
      rethrow;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
