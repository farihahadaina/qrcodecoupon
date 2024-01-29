import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qrcodecoupon/listredemption.dart';
import 'package:qrcodecoupon/loginscreen.dart';
import 'package:qrcodecoupon/logoutscreen.dart';
import 'package:qrcodecoupon/registerscreen.dart';
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
        primaryColor: Color(0xFFB5D892),
        colorScheme: ColorScheme.light(
          secondary: Colors.white, // your secondary color
        ),
      ),
      initialRoute: Routes.qrscanner,
      routes: {
        Routes.login: (context) => const LoginPage(),
        Routes.register: (context) => const RegisterPage(),
        Routes.qrscanner: (context) => const QRScanner(),
        Routes.redemption: (context) => Redemption(),
        Routes.redeemedlist: (context) => CouponList(),
        Routes.logout: (context) => Logout(),
      });
 }
}
