import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrcodecoupon/auth.dart';

class Logout extends StatelessWidget {
  Logout({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> _signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Logout');
  }

  Widget _userUid() {
    return Text('Email: ${user?.email ?? 'User email'}');
  }

  Widget _message() {
    return const Text('Are you sure you want to log out.');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: _signOut,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _title(),
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _userUid(),
                  _message(),
                  _signOutButton(),
                ])));
  }
}
