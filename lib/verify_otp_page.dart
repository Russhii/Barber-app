// lib/verify_otp_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'reset_password_page.dart';

class VerifyOtpPage extends StatefulWidget {
  final bool isPhone;
  final String? phone;
  final String? email;

  const VerifyOtpPage({
    super.key,
    required this.isPhone,
    this.phone,
    this.email,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the full 6-digit code")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      AuthResponse response;

      if (widget.isPhone) {
        response = await Supabase.instance.client.auth.verifyOTP(
          phone: widget.phone!,
          token: code,
          type: OtpType.sms,
        );
      } else {
        response = await Supabase.instance.client.auth.verifyOTP(
          email: widget.email!,
          token: code,
          type: OtpType.recovery,
        );
      }

      if (!mounted) return;

      if (response.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
              (route) => false,
        );
      }
    } on AuthException catch (e) {
      String msg = "Invalid or expired code";
      if (e.message.contains("invalid")) msg = "Invalid code";
      if (e.message.contains("expired")) msg = "Code expired. Request a new one.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.isPhone
        ? "Code sent to ${widget.phone}"
        : "Code sent to ${widget.email}";

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Image.asset('assets/images/verify_otp.png', height: 180,
                errorBuilder: (_, __, ___) => const Icon(Icons.security, size: 120, color: Colors.orange)),
            const SizedBox(height: 40),
            Text(displayText, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) => SizedBox(
                width: 50,
                height: 60,
                child: TextField(
                  controller: _controllers[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.orange, width: 2)),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 5) FocusScope.of(context).nextFocus();
                    if (v.isEmpty && i > 0) FocusScope.of(context).previousFocus();
                  },
                ),
              )),
            ),
            const SizedBox(height: 30),
            Text("Resend code in 55s", style: GoogleFonts.poppins(color: Colors.orange)),
            const Spacer(flex: 3),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verify,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B00), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Verify", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}