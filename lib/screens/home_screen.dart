import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/account.dart';
import 'package:saver/boxes.dart';
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
      return await ref
          .read(localAuthProvider)
          .authenticate(localizedReason: "perform auth");
    }, []);
    final showPassword = useState(false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(account.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(account.username),
            Text(showPassword.value ? account.password : "******"),
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
        tileColor: Colors.grey[200],
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
    );
  }
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ValueListenableBuilder<Box<Account>>(
        valueListenable: Boxes.getAccounts().listenable(),
        builder: (context, box, _) {
          final accounts = box.values.toList().cast<Account>();
          return ListView.builder(
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
