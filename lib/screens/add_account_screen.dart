import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:saver/account.dart';
import 'package:saver/boxes.dart';

class AddAccountForm extends HookWidget {
  const AddAccountForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = useState("");
    final username = useState("");
    final password = useState("");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Account name',
          ),
          onChanged: (value) => name.value = value,
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'username / email',
          ),
          onChanged: (value) => username.value = value,
        ),
        TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'password',
          ),
          onChanged: (value) => password.value = value,
          obscureText: true,
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
              final account = Account(
                name: name.value,
                username: username.value,
                password: password.value,
              );
              final box = Boxes.getAccounts();
              box.add(account);
              Navigator.pop(context);
            },
            child: const Text(
              'Create',
              style: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: AddAccountForm(),
        ),
      ),
    );
  }
}
