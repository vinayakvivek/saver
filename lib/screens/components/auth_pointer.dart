import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/providers.dart';

class AuthPointer extends HookConsumerWidget {
  const AuthPointer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final authPointerOn = useState(false);
    const authPointerDuration = Duration(milliseconds: 500);
    useEffect(() {
      Timer(authPointerDuration, () {
        authPointerOn.value = true;
      });
    });
    return AnimatedOpacity(
      duration: authPointerDuration,
      opacity: authPointerOn.value ? 1.0 : 0.0,
      onEnd: () {
        authPointerOn.value = !authPointerOn.value;
      },
      child: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: auth ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
