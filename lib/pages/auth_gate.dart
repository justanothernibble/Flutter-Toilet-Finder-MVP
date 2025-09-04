import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import 'home_screen.dart';
import 'sign_in_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = SupabaseService();
    return StreamBuilder<AuthState>(
      stream: svc.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session =
            snapshot.data?.session ?? svc.client.auth.currentSession;
        if (session != null) {
          return const HomeScreen();
        }
        return const SignInScreen();
      },
    );
  }
}
