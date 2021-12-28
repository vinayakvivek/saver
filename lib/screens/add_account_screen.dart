import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:saver/account.dart';
import 'package:saver/boxes.dart';

class AddAccountForm extends HookWidget {
  const AddAccountForm({Key? key, this.account}) : super(key: key);
  final Account? account;

  @override
  Widget build(BuildContext context) {
    final name = useState(account?.name ?? '');
    final username = useState(account?.username ?? '');
    final password = useState(account?.password ?? '');
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
              if (account != null) {
                account?.name = name.value;
                account?.username = username.value;
                account?.password = password.value;
                account?.save();
              } else {
                final newAccount = Account(
                  name: name.value,
                  username: username.value,
                  password: password.value,
                );
                final box = Boxes.getAccounts();
                box.add(newAccount);
              }

              Navigator.pop(context);
            },
            child: Text(
              account == null ? 'Create' : 'Update',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({Key? key, this.account}) : super(key: key);
  final Account? account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AddAccountForm(account: account),
        ),
      ),
    );
  }
}
