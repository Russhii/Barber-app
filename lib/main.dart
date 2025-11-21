// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'fill_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://otcqgozalgpmuzhocdlb.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im90Y3Fnb3phbGdwbXV6aG9jZGxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM2MjczODUsImV4cCI6MjA3OTIwMzM4NX0.7VXQbHbkM790MnO6CrNiGEfvN3gZtlE3d7M-24LX4_c',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salon App',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0D0D0D)),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data?.session?.user;

        if (user == null) return const LoginPage();

        return FutureBuilder(
          future: Supabase.instance.client
              .from('profiles')
              .select('full_name')
              .eq('id', user.id)
              .maybeSingle(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final hasProfile = snap.hasData && snap.data != null && (snap.data as Map)['full_name'] != null;

            if (!hasProfile) {
              return const FillProfilePage();
            }

            return const HomePage();
          },
        );
      },
    );
  }
}