import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  final String couponId;
  final String validity;
  final int price;

  Coupon(this.couponId, this.validity, this.price, isRedeemed);

  static fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
}
