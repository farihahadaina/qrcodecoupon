import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'coupon.dart';
import 'listredemption.dart';

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
  _camera = QRBarScannerCamera(
    onError: (context, error) => Text(
      error.toString(),
      style: const TextStyle(color: Colors.red),
    ),
    qrCodeCallback: (id) {
      // For simplicity, assuming default values for validity and price
      String validity = 'default_validity';
      double price = 0.0;

      setState(() {
        _qrInfo = id!;
        // Create a Coupon object and add it to the redeemedCoupons list
        Coupon coupon = Coupon(id, validity, price);
        redeemedCoupons.add(coupon);
      });

      // Open the CouponListPage to display the list of redeemed coupons
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CouponListPage(coupons: redeemedCoupons),
        ),
      );
    },
  );
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
          setState(() {
            _camState = !_camState; // Toggle the camera state
          });
        },
      ),
    );
  }
}
