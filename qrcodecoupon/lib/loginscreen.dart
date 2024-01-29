import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrcodecoupon/auth.dart';
import 'package:qrcodecoupon/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<bool> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = 'Invalid email/password entered. Please try again.';
          break;
        default:
          errorMessage = 'Invalid email/password entered. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  Widget _submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email and password cannot be empty.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        bool success = await signInWithEmailAndPassword();
        if (success) {
          Navigator.pushNamed(context, Routes.qrscanner);
        }
      },
      child: const Text('Login'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: const Text('Don\'t have an account? Register'),
    );
  }

  bool _isHiddenPassword = true;

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _controllerEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: _controllerPassword,
                obscureText: _isHiddenPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffix: InkWell(
                    onTap: _togglePasswordView,
                    child: Icon(
                      _isHiddenPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: _submitButton(context),
              ),
              _loginOrRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}
