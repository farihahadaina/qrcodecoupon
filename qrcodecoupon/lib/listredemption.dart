import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coupon.dart';
import 'package:qrcodecoupon/routes.dart';

class ListCoupon extends StatefulWidget {
  const ListCoupon({Key? key}) : super(key: key);

  @override
  State<ListCoupon> createState() => _ListCouponState();
}

class _ListCouponState extends State<ListCoupon> with SingleTickerProviderStateMixin {
  List<Coupon> coupons = [];
  int _currentIndex = 0;

  final _userStream = FirebaseFirestore.instance.collection('coupon.entries').snapshots();

  @override
  void initState() {
    super.initState();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('coupon_entries')
        .where('isRedeemed', isEqualTo: true)
        .get();
    final coupons = snapshot.docs.map((doc) => Coupon.fromSnapshot(doc)).toList();
    setState(() {
      this.coupons = coupons as List<Coupon>;
    });
  }

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
                  title: Text('Coupon ID: ${coupons[index].code}'),
                  subtitle: Text('Price: \$${coupons[index].price}', style: const TextStyle(fontSize: 18)),
                  trailing: Text('Validity: ${coupons[index].validity}', style: const TextStyle(fontSize: 18)),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
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
