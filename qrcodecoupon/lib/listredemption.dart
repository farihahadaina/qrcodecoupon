import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coupon.dart';
import 'package:qrcodecoupon/routes.dart';
import 'package:intl/intl.dart';

class ListCoupon extends StatefulWidget {
 const ListCoupon({Key? key}) : super(key: key);

 @override
 State<ListCoupon> createState() => _ListCouponState();
}

class _ListCouponState extends State<ListCoupon> {
 List<Coupon> coupons = [];
 int _currentIndex = 1;

 Future<void> getCoupons() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('coupon_entries').get();
    querySnapshot.docs.forEach((doc) {
      final couponId = doc.get('couponId');
      final Timestamp validityTimestamp = doc.get('validity');
      final DateTime validityDateTime = validityTimestamp.toDate();
      final String validity = DateFormat('yyyy-MM-dd – kk:mm').format(validityDateTime);
      final price = doc.get('price');
      final isRedeemed = doc.get('isRedeemed');
      final coupon = Coupon(couponId, validity, price, isRedeemed);
      if (isRedeemed) {
        setState(() {
          coupons.add(coupon);
        });
      }
    });
 }

 @override
 void initState() {
    super.initState();
    getCoupons();
 }

 Widget allCouponDetails() {
    return Container(
      height: 600, // Adjust this value as needed
      child: coupons.isEmpty ? const Text('No data') : ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code),
              title: Text('Coupon ID: ${coupon.couponId}', style: const TextStyle(fontSize: 18)),
              subtitle: Text('Price: \$${coupon.price}', style: const TextStyle(fontSize: 18)),
              trailing: Text('Validity: ${coupon.validity}', style: const TextStyle(fontSize: 18)),
            ),
          );
        },
      ),
    );
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('My Coupon'),
      ),
      body:ListView(
        children: [
          allCouponDetails(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
