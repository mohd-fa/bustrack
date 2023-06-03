import 'package:bustrack/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bustrack/screens/loading.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  // text field state
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  String? errorMessage;

  Future signInWithEmailAndPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(_emailTextEditingController.text,
          _passwordTextEditingController.text);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Sign up to Bus Track Flut'),
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      controller: _emailTextEditingController,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      controller: _passwordTextEditingController,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        child: const Text(
                          'Sign In',
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await signInWithEmailAndPassword();
                            if (result == null) {
                              setState(() {
                                // errorMessage = 'Invalid Credentials';
                                loading = false;
                              });
                            }
                          }
                        }),
                    const SizedBox(height: 12.0),
                    Text(
                      errorMessage ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
