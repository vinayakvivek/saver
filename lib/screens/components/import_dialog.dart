import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:saver/context_utils.dart';
import 'package:saver/utils.dart';

class ImportDialog extends HookWidget {
  const ImportDialog({Key? key, required this.file}) : super(key: key);
  final File file;

  @override
  Widget build(BuildContext context) {
    final passphrase = useState("");
    final fileName = file.path.split('/').last;
    return AlertDialog(
      title: const Text('Import data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data file:"),
          Text(
            fileName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'passphrase'),
            onChanged: (value) => passphrase.value = value,
          ),
          const SizedBox(height: 20.0),
          const Text(
            "** This action will remove all existing accounts",
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () async {
            if (passphrase.value.isEmpty) {
              showSnackbar(context, 'Please enter a passphrase');
            } else {
              // TODO: use either to manage error flow
              try {
                importAccountsFromFile(
                    file: file, passphrase: passphrase.value);
                Navigator.pop(context, 'Import');
                showSnackbar(context, 'Successfully imported data');
              } catch (err) {
                print(err);
                showSnackbar(context, 'Error while importing');
              }
            }
          },
          child: const Text('Import'),
        ),
      ],
    );
  }
}
