import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:saver/utils.dart';

class ExportDialog extends HookWidget {
  const ExportDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passphrase = useState("");
    final showSnackbar = useCallback((String text, {int seconds = 1}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          duration: Duration(seconds: seconds),
        ),
      );
    }, []);
    return AlertDialog(
      title: const Text('Export your data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Type in a passphrase to encrypt your passwords/secrets'),
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
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () async {
            if (passphrase.value.isEmpty) {
              showSnackbar('Please enter a passphrase');
            } else {
              // TODO: use either to manage error flow
              try {
                final outFile =
                    await exportAccountsToFile(passphrase: passphrase.value);
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
    );
  }
}
