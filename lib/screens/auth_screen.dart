
import 'package:comments_app/screens/comment_screen.dart';
import 'package:comments_app/widgets/loading_spinner.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        if (authProvider.isSignup) {
          await authProvider.signin(authProvider.email, authProvider.password);
        } else {
          await authProvider.login(authProvider.email, authProvider.password);
        }
      } catch (e) {
        print("Error in auth: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<fbAuth.User?>(
        stream: fbAuth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return LoadingSpinner();
          } else if (userSnapshot.data != null) {
            return CommentScreen();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Comments",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (authProvider.isSignup)
                          _buildTextField(
                            label: "Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              authProvider.setName(value ?? "");
                            },
                          ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: "Email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || !value.contains("@")) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            authProvider.setEmail(value ?? "");
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: "Password",
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            authProvider.setPassword(value ?? "");
                          },
                        ),
                        const Spacer(),
                        authProvider.isLoading
                            ? LoadingSpinner()
                            : _buildSubmitButton(authProvider, context),
                        const SizedBox(height: 16),
                        _buildToggleButton(authProvider, context),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildSubmitButton(AuthProvider authProvider, BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () => _submitForm(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: Text(
          authProvider.isSignup ? "Signup" : "Login",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildToggleButton(AuthProvider authProvider, BuildContext context) {
    return TextButton(
      onPressed: () {
        authProvider.toggleRegister();
      },
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
                text: authProvider.isSignup
                    ? "Already have an account? "
                    : "New here "),
            TextSpan(
              text: authProvider.isSignup ? "Login" : "Signup",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
