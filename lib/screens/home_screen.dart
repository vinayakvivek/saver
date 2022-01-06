import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/context_utils.dart';
import 'package:saver/models/account.dart';
import 'package:saver/boxes.dart';
import 'package:saver/screens/account_screen.dart';
import 'package:saver/screens/components/account_tile.dart';
import 'package:saver/screens/components/auth_pointer.dart';
import 'package:saver/screens/components/export_dialog.dart';
import 'package:saver/screens/components/import_dialog.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Accounts"),
            SizedBox(width: 10.0),
            AuthPointer(),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              doPostAuth(
                ref,
                () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => const ExportDialog(),
                ),
              );
            },
            icon: const Icon(Icons.ios_share),
          ),
          IconButton(
            onPressed: () async {
              doPostAuth(ref, () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  File file = File(result.files.single.path!);
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          ImportDialog(file: file));
                } else {
                  // User canceled the picker
                }
              });
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Account>>(
        valueListenable: Boxes.getAccounts().listenable(),
        builder: (context, box, _) {
          final accounts = box.values.toList().cast<Account>();
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0, bottom: 150),
            itemBuilder: (context, index) {
              final account = accounts[index];
              return AccountTile(account: account);
            },
            itemCount: accounts.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountScreen(account: Account.empty()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
