import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:saver/screens/auth_screen.dart';
import 'package:saver/screens/home_screen.dart';

final localAuthProvider = Provider((_) => LocalAuthentication());

final authProvider = FutureProvider<bool>((ref) async {
  final LocalAuthentication auth = ref.read(localAuthProvider);
  return await auth.authenticate(localizedReason: "any auth");
});

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key, required this.isError}) : super(key: key);
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isError
          ? const Center(child: Text("Error while authenticating"))
          : const CircularProgressIndicator(),
    );
  }
}

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return auth.when(
      data: (value) {
        return value ? const HomeScreen() : const AuthScreen();
      },
      error: (err, stack) => const LoadingScreen(isError: true),
      loading: () => const LoadingScreen(isError: false),
    );
  }
}
