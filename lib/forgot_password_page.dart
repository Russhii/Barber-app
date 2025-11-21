// lib/forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'verify_otp_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? selectedEmail;
  String? selectedPhone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(backgroundColor: Colors.transparent, leading: const BackButton(color: Colors.white70)),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Spacer(),
            Image.asset('assets/images/forgot_password.png', height: 200),
            const SizedBox(height: 40),
            Text("Forgot Password", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Text("Select contact to receive reset code", textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white60)),
            const SizedBox(height: 40),
            _ContactOption(
              icon: Icons.sms,
              title: "via SMS:",
              value: "+1 234 567 8900",
              isSelected: selectedPhone != null,
              onTap: () => setState(() => selectedPhone = "+12345678900"),
            ),
            const SizedBox(height: 16),
            _ContactOption(
              icon: Icons.email,
              title: "via Email:",
              value: "user@example.com",
              isSelected: selectedEmail != null,
              onTap: () => setState(() => selectedEmail = "user@example.com"),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: selectedEmail == null && selectedPhone == null ? null : () async {
                  try {
                    if (selectedEmail != null) {
                      await Supabase.instance.client.auth.resetPasswordForEmail(selectedEmail!);
                    } else {
                      await Supabase.instance.client.auth.signInWithOtp(phone: selectedPhone!);
                    }
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerifyOtpPage(
                          isPhone: selectedPhone != null,
                          phone: selectedPhone,
                          email: selectedEmail,
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: $e")));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B00), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                child: const Text("Continue", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContactOption({required this.icon, required this.title, required this.value, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.orange : Colors.white24),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 24, backgroundColor: Colors.white.withOpacity(0.1), child: Icon(icon, color: Colors.orange)),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white60)),
              Text(value, style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
            ]),
          ],
        ),
      ),
    );
  }
}