// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> with SingleTickerProviderStateMixin {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRBarScannerCamera _camera;
  bool _camState = false;
  String _qrInfo = 'Scan your coupon here';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _tabController = TabController(length: 3, vsync: this);
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
            } else {
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
                          Navigator.pushNamed(context, '/qrscanner');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
        setState(() {
          _qrInfo = couponId!;
        });

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
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Column(
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
          // Replace these with your actual screens
          const QRScanner(),
          
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