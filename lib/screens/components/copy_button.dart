import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/context_utils.dart';

class CopyButton extends HookConsumerWidget {
  const CopyButton({
    Key? key,
    required this.getText,
  }) : super(key: key);
  final String Function() getText;

  final copyingDuration = const Duration(seconds: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copying = useState(false);
    return IconButton(
      onPressed: () async {
        doPostAuth(ref, () {
          Clipboard.setData(ClipboardData(text: getText()));
          copying.value = true;
          Timer(copyingDuration, () {
            copying.value = false;
          });
        });
      },
      icon: Icon(copying.value ? Icons.check : Icons.copy),
    );
  }
}
