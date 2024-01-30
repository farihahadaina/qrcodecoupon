import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coupon.dart';
import 'package:qrcodecoupon/routes.dart';

class ListCoupon extends StatefulWidget {
  const ListCoupon({Key? key}) : super(key: key);

  @override
  State<ListCoupon> createState() => _ListCouponState();
}

class _ListCouponState extends State<ListCoupon> {
  List<Coupon> coupons = [];
  int _currentIndex = 0;

Stream<QuerySnapshot<Map<String, dynamic>>> couponStream =
    FirebaseFirestore.instance.collection('coupon.entries').snapshots();

onLoad() async {}
  @override
  void initState() {
    onLoad();
    super.initState();
  }

Widget allCouponDetails() {
  return StreamBuilder<QuerySnapshot>(
    stream: couponStream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Text('Connection error');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Loading...');
      }

      var docs = snapshot.data?.docs;

      return snapshot.hasData ? ListView.builder(
        itemCount: docs?.length,
        itemBuilder: (context, index) {
          // Access the data directly from the current document
          final code = docs?[index].get('code');
          final validity = docs?[index].get('validity');
          final price = docs?[index].get('price');
          final isRedeemed = docs?[index].get('isRedeemed');
          final coupon = Coupon(code, validity, price, isRedeemed);
          if (!isRedeemed) {
            coupons.add(coupon);
          }

          return Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code),
              title: Text('Coupon ID: $code', style: const TextStyle(fontSize: 18)),
              subtitle: Text('Price: \$$price', style: const TextStyle(fontSize: 18)),
              trailing: Text('Validity: $validity', style: const TextStyle(fontSize: 18)),
            ),
          );
        },
      ) : const Text('No data');
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Coupon'),
      ),
      body:ListView(
        children: [
          allCouponDetails(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          switch (newIndex) {
            case 0:
              Navigator.pushNamed(context, Routes.qrscanner);
              break;
            case 1:
              Navigator.pushNamed(context, Routes.listredemption);
              break;
            case 2:
              Navigator.pushNamed(context, Routes.profile);
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_sharp),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My Coupon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
      ),
    );
  }
  
}
