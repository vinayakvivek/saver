import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String text, {int seconds = 1}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: seconds),
    ),
  );
}
