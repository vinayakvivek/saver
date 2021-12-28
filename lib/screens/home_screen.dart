import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/account.dart';
import 'package:saver/boxes.dart';
import 'package:saver/screens/add_account_screen.dart';
import 'package:saver/screens/splash_screen.dart';

class AccountTile extends HookConsumerWidget {
  const AccountTile({Key? key, required this.account}) : super(key: key);
  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localAuth = ref.read(localAuthProvider);
    final showPassword = useState(false);
    return ListTile(
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
        final auth =
            await localAuth.authenticate(localizedReason: "specific auth");
        if (auth) {
          showPassword.value = true;
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            MaterialPageRoute(builder: (context) => const AddAccountScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
