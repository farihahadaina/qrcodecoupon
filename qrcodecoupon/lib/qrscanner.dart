import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';

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
  bool _camState = false;
  String _qrInfo = 'Scan your coupon here';

  @override
  void initState() {
    super.initState();
    _camera = QRBarScannerCamera(
      onError: (context, error) => Text(
        error.toString(),
        style: const TextStyle(color: Colors.red),
      ),
      qrCodeCallback: (code) {
        setState(() {
          _qrInfo = code!;
        });
      },
    );
    _camState = true;
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
          Navigator.pushNamed('/qrscanner' as BuildContext, '/thirdscreen');
        },
      ),
    );
  }
}