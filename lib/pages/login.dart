import 'package:dekita_flutter_firebase/components/my_text_form_field.dart';
import 'package:dekita_flutter_firebase/scaffolds/form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();
  Exception? exception;

  void _login() async {
    String email = _emailTextEditingController.text;
    String password = _passwordTextEditingController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception catch (exception) {
      setState(() {
        this.exception = exception;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: 'Sign in',
      body: Form(
        key: _formKey,
        child: Column(
          spacing: config.defaultSpacing,
          children: [
            if (exception != null)
              Text(exception.toString(), style: TextStyle(color: Colors.red)),
            MyTextFormField(
              controller: _emailTextEditingController,
              labelText: 'Email',
              autofocus: true,
            ),
            MyTextFormField(
              controller: _passwordTextEditingController,
              labelText: 'Password',
              obscureText: true,
            ),
            ElevatedButton(onPressed: _login, child: Text('Sign in')),
          ],
        ),
      ),
    );
  }
}
