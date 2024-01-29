import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coupon.dart';

class CouponList extends StatefulWidget {
  const CouponList({Key? key}) : super(key: key);

  @override
  State<CouponList> createState() => _CouponListState(); 
}

class _CouponListState extends State<CouponList> {
  List<Coupon> coupons = [];

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
        title: const Text('Redeemed Coupons'),
      ),
      body: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Coupon ID: ${coupons[index].code}'),
            subtitle: Text('Price: \$${coupons[index].price}', style: const TextStyle(fontSize: 18)),
            trailing: Text('Expiry Date: ${coupons[index].validity}', style: const TextStyle(fontSize: 18)),
          );
        },
      ),
    );
  }}
