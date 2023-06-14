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
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _classTextEditingController =
      TextEditingController();
  final TextEditingController _divTextEditingController =
      TextEditingController();
  String? errorMessage;
  bool loading = false;
  RegExp alpha = RegExp('^[a-zA-Z]+');
  RegExp nums = RegExp('^[0-9]+');

  Future registerWithEmailAndPassword(String admin) async {
    try {
      errorMessage = '';
      await _auth.registerWithEmailAndPassword(
          _emailTextEditingController.text,
          _passwordTextEditingController.text,
          _nameTextEditingController.text,
          _classTextEditingController.text,
          _divTextEditingController.text,
          admin);
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
            body: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an valid email' : null,
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
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      keyboardType: TextInputType.name,
                      validator: (val) =>
                          val!.isEmpty || val.contains(alpha) ? 'Enter a valid name for the student.' : null,
                      controller: _nameTextEditingController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Class', counterText: ''),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      validator: (val) =>
                          val!.isEmpty || val.contains(nums) ? 'Enter class of student.' : null,
                      controller: _classTextEditingController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Division', counterText: ''),
                      keyboardType: TextInputType.name,
                      maxLength: 1,
                      validator: (val) =>
                          val!.isEmpty || val.contains(alpha) ? 'Enter division of student.' : null,
                      controller: _divTextEditingController,
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
