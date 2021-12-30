import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/models/account.dart';
import 'package:saver/boxes.dart';
import 'package:saver/screens/account_screen.dart';
import 'package:saver/screens/components/account_tile.dart';
import 'package:saver/utils.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passphrase = useState("");
    final showSnackbar = useCallback((String text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accounts"),
        actions: [
          IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Export your data'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        'Type in a passphrase to encrypt your passwords/secrets'),
                    TextField(
                      decoration: const InputDecoration(hintText: 'passphrase'),
                      onChanged: (value) => passphrase.value = value,
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () async {
                      if (passphrase.value.isEmpty) {
                        showSnackbar('Please enter a passphrase');
                      } else {
                        // TODO: use either to manage error flow
                        try {
                          final outFile = await exportAccountsToFile(
                              passphrase: passphrase.value);
                          print('Exported data to: ${outFile.path}');
                          showSnackbar('Exported successfully');
                          Navigator.pop(context, 'Export');
                        } catch (err) {
                          print(err);
                          showSnackbar('Error while exporting');
                        }
                      }
                    },
                    child: const Text('Export'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Account>>(
        valueListenable: Boxes.getAccounts().listenable(),
        builder: (context, box, _) {
          final accounts = box.values.toList().cast<Account>();
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0),
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
