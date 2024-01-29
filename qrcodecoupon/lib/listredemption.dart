import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcodecoupon/qrscanner.dart';
import 'coupon.dart';

class CouponList extends StatefulWidget {
  const CouponList({Key? key}) : super(key: key);

  @override
  State<CouponList> createState() => _CouponListState(); 
}

class _CouponListState extends State<CouponList> with SingleTickerProviderStateMixin {
  List<Coupon> coupons = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchCoupons();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Redeemed Coupons'),
      bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.qr_code_scanner_sharp),
            ),
            Tab(
              icon: Icon(Icons.list),
            ),
            Tab(
              icon: Icon(Icons.account_circle_outlined),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView.builder(
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Coupon ID: ${coupons[index].code}'),
                subtitle: Text('Price: \$${coupons[index].price}', style: const TextStyle(fontSize: 18)),
                trailing: Text('Expiry Date: ${coupons[index].validity}', style: const TextStyle(fontSize: 18)),
              );
            },
          ),
          // Replace these with your actual screens
          const QRScanner(),
          const CouponList(),
          //const UserProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.qr_code_scanner_sharp),
            ),
            Tab(
              icon: Icon(Icons.list),
            ),
            Tab(
              icon: Icon(Icons.account_circle_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
