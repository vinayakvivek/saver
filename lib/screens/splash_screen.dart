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

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    // ref.listen(authProvider, (previous, next) {
    //   if (next != null) {
    //     next = next as AsyncData;
    //     if (next.value) {
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => const HomeScreen()));
    //     }
    //   }
    // });
    // ref.listen(authProvider.future, (previous, next) {
    //   print(previous);
    //   print(next);
    // });
    // auth.whenData((value) {
    //   if (value) {
    //     Future.delayed(Duration.zero, () {
    //       Navigator.push(context,
    //           MaterialPageRoute(builder: (context) => const HomeScreen()));
    //     });
    //   }
    // });
    return auth.when(
      data: (value) {
        return value ? const HomeScreen() : const AuthScreen();
      },
      error: (err, stack) => const Text("Err"),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
