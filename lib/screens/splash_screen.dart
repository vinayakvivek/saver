import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/screens/home_screen.dart';

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
    return const HomeScreen();
  }
}
