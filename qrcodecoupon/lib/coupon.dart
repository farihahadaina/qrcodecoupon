import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  final String code;
  final String validity;
  final double price;

  Coupon(this.code, this.validity, this.price, isRedeemed);

  static fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
}
