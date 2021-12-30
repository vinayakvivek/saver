import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/models/account.dart';
import 'package:saver/providers.dart';
import 'package:saver/screens/account_screen.dart';

class AccountTile extends HookConsumerWidget {
  const AccountTile({Key? key, required this.account}) : super(key: key);
  final Account account;

  final showPasswordDuration = const Duration(seconds: 10);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final localAuth = ref.read(localAuthProvider);
    final performAuth = useCallback(() async {
      // ! for testing
      return true;
      return await ref
          .read(localAuthProvider)
          .authenticate(localizedReason: "perform auth");
    }, []);
    final showPassword = useState(false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 1,
              onPressed: (context) => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete Account?'),
                  content: Text(
                      'Do you want to delete the account: ${account.name}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () {
                        account.delete();
                        Navigator.pop(context, 'Delete');
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[900]),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            title: Text(
              account.name,
              style: const TextStyle(fontSize: 20.0),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Text(
                  account.username,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                Text(showPassword.value ? account.password : "******",
                    style: const TextStyle(fontSize: 16.0)),
              ],
            ),
            leading: const FlutterLogo(size: 56.0),
            onTap: () async {
              if (showPassword.value) {
                showPassword.value = false;
                return;
              }
              if (await performAuth()) {
                showPassword.value = true;
                Timer(showPasswordDuration, () {
                  showPassword.value = false;
                });
              }
            },
            trailing: IconButton(
                onPressed: () async {
                  if (!(await performAuth())) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountScreen(
                        account: account,
                        isUpdate: true,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit)),
          ),
        ),
      ),
    );
  }
}
