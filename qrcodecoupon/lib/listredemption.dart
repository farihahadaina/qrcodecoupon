import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcodecoupon/qrscanner.dart';
import 'coupon.dart';
import 'package:qrcodecoupon/routes.dart';

class CouponList extends StatefulWidget {
  const CouponList({Key? key}) : super(key: key);

  @override
  State<CouponList> createState() => _CouponListState();
}

class _CouponListState extends State<CouponList>
    with SingleTickerProviderStateMixin {
  List<Coupon> coupons = [];
  // late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCoupons();
    // _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> fetchCoupons() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('coupon_entries')
        .where('isRedeemed', isEqualTo: true)
        .get();
    final coupons =
        snapshot.docs.map((doc) => Coupon.fromSnapshot(doc)).toList();
    setState(() {
      this.coupons = coupons as List<Coupon>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Redeemed Coupons'),
      ),
      body: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Coupon ID: ${coupons[index].code}'),
            subtitle: Text('Price: \$${coupons[index].price}',
                style: const TextStyle(fontSize: 18)),
            trailing: Text('Expiry Date: ${coupons[index].validity}',
                style: const TextStyle(fontSize: 18)),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        //unselectedItemColor: Colors.white,
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
              Navigator.pushNamed(context, Routes.redeemedlist);
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
