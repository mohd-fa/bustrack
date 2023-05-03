import 'package:bustrack/screens/loading.dart';
import 'package:bustrack/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bustrack/models/models.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final SecondaryAuthService _auth = SecondaryAuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  String? errorMessage;
  bool loading = false;

  Future registerWithEmailAndPassword(String admin) async {
    try {
      errorMessage = '';
      await _auth.registerWithEmailAndPassword(_emailTextEditingController.text,
          _passwordTextEditingController.text, admin);
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),
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
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      controller: _passwordTextEditingController,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        child: const Text(
                          'Register',
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await registerWithEmailAndPassword(
                                Provider.of<AppUser>(context, listen: false)
                                    .uid);
                            if (result == null) {
                              setState(() {
                                //errorMessage = 'Please supply a valid email';
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
