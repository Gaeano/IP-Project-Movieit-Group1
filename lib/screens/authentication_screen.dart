import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieit/widgets/login_form.dart';
import 'package:movieit/widgets/signup_form.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _showLoginForm = true;

  void _toggleForm() {
    setState(() {
      _showLoginForm = !_showLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E0A52),
              Colors.black,
              Color(0xFF032D6C),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 38,
              left: 24,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.go('/'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'icons/popcorn_icon.png',
                        color: Colors.white,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'MovieIT',
                        style: GoogleFonts.bagelFatOne(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _showLoginForm
                      ? LoginForm(
                          key: const ValueKey('login'),
                          onToggle: _toggleForm,
                        )
                      : SignupForm(
                          key: const ValueKey('signup'),
                          onToggle: _toggleForm,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
