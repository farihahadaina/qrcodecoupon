import 'package:flutter/material.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ListCoupon extends StatefulWidget {
  const ListCoupon({Key? key}) : super(key: key);

  @override
  State<ListCoupon> createState() => _ListCouponState();
}

class _ListCouponState extends State<ListCoupon> {
  final _userStream =
      FirebaseFirestore.instance.collection('coupon.entries').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Coupon'),
      ),
      body: StreamBuilder(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Connection error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          var docs = snapshot.data!.docs;
          //return Text('${docs.length}');
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: Text(docs[index]['couponId']),
                  subtitle: Text(docs[index]['validity'].toString()),
                  trailing: Text(docs[index]['price'].toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
