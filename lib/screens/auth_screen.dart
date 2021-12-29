import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/providers.dart';
import 'package:saver/screens/home_screen.dart';

class AuthScreen extends HookConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localAuth = ref.read(localAuthProvider);
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () async {
            final auth =
                await localAuth.authenticate(localizedReason: "re-auth");
            if (auth) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }
          },
          child: const Text("Authenticate"),
          color: Colors.grey,
        ),
      ),
    );
  }
}
