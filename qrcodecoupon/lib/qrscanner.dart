// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'listcoupon.dart';
import 'coupon.dart';
import 'routes.dart';
import 'redemption.dart';


class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  // ignore: unused_field
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRBarScannerCamera _camera;
  bool _camState = true; // Set to true by default
  String _qrInfo = 'Scan your coupon here';
  List<Coupon> redeemedCoupons = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() {
    _camera = QRBarScannerCamera(
      onError: (context, error) => Text(
        error.toString(),
        style: const TextStyle(color: Colors.red),
      ),
      qrCodeCallback: (couponId) async {
        if (_camState) {
          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('coupon_entries')
              .doc(couponId)
              .get();

          if (doc.exists) {
            bool isRedeemed = doc.get('isRedeemed');
            if (!isRedeemed) {
              Navigator.pushNamed(context, '/redemption', arguments: couponId);
            }
            else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Unsuccessful Redemption',
                        style: TextStyle(color: Colors.red, fontSize: 24),
                      ),
                      content: const Text(
                        'Sorry, the scanned coupon has already been redeemed.',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Navigator.of(context).pop();
                            Navigator.pushNamed(context, '/qrscanner');
                          },
                          child: const Text('OK'),
                        ),
                      ]
                    );
                  },
                );
              }
            }
        }
        setState(() {
_qrInfo = 'Coupon Code: ${couponId!}\n';

  // Assuming couponId has a format like "code_validity_price"
  List<String> parts = couponId.split('_');
  String code = parts[0];
  String validity = parts[1];
  double price = double.parse(parts[2]);

  Coupon coupon = Coupon(code, validity, price);
  redeemedCoupons.add(coupon);
});

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CouponListPage(coupons: redeemedCoupons),
  ),
);

        _resetStateAfterScan();
      },
    );
    _camState = true;
  }

  void _resetStateAfterScan() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _qrInfo = 'Scan your coupon here';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupon Scanner'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: _camera,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                _qrInfo,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_camState ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          if (_camState == true) {
            setState(() {
              _camState = false;
            });
          } else {
            setState(() {
              _camState = true;
            });
          }
        },
      ),
    );
  }
}
