import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coupon.dart';

class ListCoupon extends StatefulWidget {
  const ListCoupon({Key? key}) : super(key: key);

  @override
  State<ListCoupon> createState() => _ListCouponState();
}

class _ListCouponState extends State<ListCoupon>
    with SingleTickerProviderStateMixin {
  List<Coupon> coupons = [];
  // late TabController _tabController;
  int _currentIndex = 0;

  final _userStream =
      FirebaseFirestore.instance.collection('coupon.entries').snapshots();
  State<CouponList> createState() => _CouponListState();

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
    );
  }
}
