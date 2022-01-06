import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/icons/example_icon.dart';
import 'package:saver/icons/icons.dart';
import 'package:saver/models/account.dart';
import 'package:saver/boxes.dart';
import 'package:saver/screens/components/copy_button.dart';
import 'package:saver/screens/components/icon_selector_dialog.dart';

class AccountForm extends HookConsumerWidget {
  const AccountForm({
    Key? key,
    required this.account,
    required this.isUpdate,
  }) : super(key: key);
  final Account account;
  final bool isUpdate;

  final copyingDuration = const Duration(seconds: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState(account.name);
    final username = useState(account.username);
    final password = useState(account.password);
    final nameController = useTextEditingController(text: name.value);
    final usernameController = useTextEditingController(text: username.value);
    final passwordController = useTextEditingController(text: password.value);
    final showPassword = useState(false);
    final icon = useState(getIconByName(account.iconName ?? ''));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 100.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final result = await showDialog<ExampleIcon>(
                  context: context,
                  builder: (context) => const IconSelectorDialog(),
                );
                if (result != null) {
                  icon.value = result;
                }
              },
              child: Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.red,
                ),
                child: Center(
                  child: FaIcon(
                    icon.value.iconData,
                    size: 40.0,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 30.0),
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            // border: OutlineInputBorder(),
            hintText: 'Account name',
          ),
          textAlign: TextAlign.center,
          onChanged: (value) => name.value = value,
        ),
        const SizedBox(height: 50.0),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'username',
            hintText: 'Your username or email',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CopyButton(getText: () => username.value),
              ],
            ),
          ),
          onChanged: (value) => username.value = value,
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'password',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showPassword.value = !showPassword.value;
                  },
                  icon: Icon(showPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
                CopyButton(getText: () => password.value),
              ],
            ),
          ),
          onChanged: (value) => password.value = value,
          obscureText: !showPassword.value,
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 20.0),
              ),
            ),
            onPressed: () {
              account.name = name.value;
              account.username = username.value;
              account.password = password.value;
              account.iconName = icon.value.title;
              if (isUpdate) {
                account.save();
              } else {
                // create new
                final box = Boxes.getAccounts();
                box.add(account);
              }
              Navigator.pop(context);
            },
            child: Text(isUpdate ? 'Update' : 'Create'),
          ),
        )
      ],
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key, required this.account, this.isUpdate = false})
      : super(key: key);
  final Account account;
  final bool isUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AccountForm(account: account, isUpdate: isUpdate),
        ),
      ),
    );
  }
}
