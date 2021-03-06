import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/models/account.dart';
import 'package:saver/boxes.dart';

class AccountForm extends HookConsumerWidget {
  const AccountForm({
    Key? key,
    required this.account,
    required this.isUpdate,
  }) : super(key: key);
  final Account account;
  final bool isUpdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useState(account.name);
    final username = useState(account.username);
    final password = useState(account.password);
    final nameController = useTextEditingController(text: name.value);
    final usernameController = useTextEditingController(text: username.value);
    final passwordController = useTextEditingController(text: password.value);
    final showPassword = useState(false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Account name',
          ),
          onChanged: (value) => name.value = value,
        ),
        TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'username / email',
          ),
          onChanged: (value) => username.value = value,
        ),
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: 'password',
            suffixIcon: IconButton(
              onPressed: () {
                showPassword.value = !showPassword.value;
              },
              icon: Icon(
                  showPassword.value ? Icons.visibility_off : Icons.visibility),
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
            ),
            onPressed: () {
              account.name = name.value;
              account.username = username.value;
              account.password = password.value;
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
