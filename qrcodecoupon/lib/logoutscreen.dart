import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrcodecoupon/auth.dart';
import 'package:qrcodecoupon/routes.dart';

class Logout extends StatelessWidget {
  Logout({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> _signOut() async {
    await Auth().signOut();
  }

  Widget _message() {
    return const Text(
      'Are you sure want to logout?',
      style: TextStyle(fontSize: 21), // Increase the font size here
    );
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, Routes.login);
      },
      child: const Text(
        'Sign Out',
        style: TextStyle(fontSize: 21),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Logging out...'),
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _message(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _signOutButton(context),
                  ),
                ])));
  }
}
