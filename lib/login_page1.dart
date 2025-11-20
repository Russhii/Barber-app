import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'email_password_login.dart';
import 'signup_page.dart';

class EmailLoginPage extends StatelessWidget {
  const EmailLoginPage({super.key});

  Future<void> _googleSignIn(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://auth-callback',
      );
    } on AuthException catch (e) {
      // Silently ignore the known 404 redirect error in debug mode
      if (e.message.toLowerCase().contains('404') ||
          e.message.toLowerCase().contains('redirect')) {
        print('Ignored expected OAuth 404 (debug mode): ${e.message}');
        // Session will still be picked up by AuthWrapper stream
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-in failed: ${e.message}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-in failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Icon(Icons.cut, size: 120, color: Colors.orange),
              const SizedBox(height: 60),
              const Text("Let's you in",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _googleSignIn(context),
                  icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 36),
                  label: const Text(
                    "Continue with Google",
                    style: TextStyle(fontSize: 16, color: Colors.white), // reduced from 18 → 16
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E2E2E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Row(children: [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("or", style: TextStyle(color: Colors.grey))),
                Expanded(child: Divider(color: Colors.grey))
              ]),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EmailPasswordLoginScreen())),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text("Sign in with password",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignUpPage())),
                    child: const Text("Sign up",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}