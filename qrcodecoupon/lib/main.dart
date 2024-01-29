import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qrcodecoupon/listredemption.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'redemption.dart';
import 'qrscanner.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
 );
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

 // This widget is the root of your application.
 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahabbah Food Coupon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),    
        //primarySwatch: Colors.cyan,    
        primaryColor: Color(0xFFC4E2A6),
      ),
      initialRoute: Routes.qrscanner,
      routes: {
        Routes.qrscanner: (context) => const QRScanner(),
        Routes.redemption: (context) => Redemption(),
        Routes.redeemedlist: (context) => CouponList(),
      });
 }
}
