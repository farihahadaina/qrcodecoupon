import 'package:flutter/material.dart';
import 'coupon.dart';

class CouponListPage extends StatelessWidget {
  final List<Coupon> coupons;

  const CouponListPage({super.key, required this.coupons});

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
            title: Text('Coupon ID: ${coupons[index].id}'),
            // Add more details here if needed
          );
        },
      ),
    );
  }
}
