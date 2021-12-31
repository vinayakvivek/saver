import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/constants.dart';
import 'package:saver/providers.dart';

void showSnackbar(BuildContext context, String text, {int seconds = 1}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: seconds),
    ),
  );
}

Future<bool> performAuth(WidgetRef ref) async {
  print('in performAuth');
  final auth = ref.read(authStateProvider.notifier);
  if (auth.state) {
    return true;
  }
  final result = await ref
      .read(localAuthProvider)
      .authenticate(localizedReason: "perform auth");
  if (result) {
    auth.state = true;
    Timer(kAuthenticatedDuration, () {
      print('resetting state');
      ref.read(authStateProvider.notifier).state = false;
    });
  }
  return result;
}

void doPostAuth(WidgetRef ref, VoidCallback fn) async {
  final auth = await performAuth(ref);
  if (auth) {
    fn();
  }
}
