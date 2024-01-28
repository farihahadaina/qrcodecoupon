//import 'routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'qrscanner.dart';

class Redemption extends StatefulWidget {
  const Redemption({Key? key}) : super(key: key);

  @override
  State<Redemption> createState() => _RedemptionState();  
}

class _RedemptionState extends State<Redemption> {
  String couponId = '';
  DateTime validity = DateTime.now();
  double price = 0.0;


@override
  void initState() {
    super.initState();
    // redeemCoupon();
}

@override
  void didChangeDependencies() { //didChangeDependencies means when the state of the widget changes (when the widget is built), it's different from initState which is only called once because it's called before the widget is built
    super.didChangeDependencies();
    final String couponId = ModalRoute.of(context)!.settings.arguments as String;
    this.couponId = couponId;
    redeemCoupon();
}


 Future<void> redeemCoupon() async {
    //DocumentSnapshot doc = await FirebaseFirestore.instance.collection('coupon_entries').doc(widget.couponId).get();
    DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('coupon_entries')
      .doc(couponId)
      .get();
    if (doc.exists) {
      await FirebaseFirestore.instance
        .collection('coupon_entries')
        .doc(couponId)
        .update({'isRedeemed': true});
         //to update the isRedeemed field to true in firebase
      setState(() {
        //couponId = widget.couponId; //couponId is empty string if no coupon ID is passed from QRScanner
        couponId = couponId;
        validity = (doc.get('validity') as Timestamp).toDate(); // to get the expiry date from firebase and convert it to DateTime format which is readable by flutter 
        price = doc.get('price');
      });      
    } else {
      //print('No coupon found with this ID');
      couponId = 'No coupon found with this ID';
    }
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mahabbah Food Coupon'),
      ),
      body: Center(
        //child: Text('Coupon ID: $couponId'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.green,
              radius: 30.0,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 10),
            Container(child:
              const Text(
                'Successfully redeemed!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold, 
                ),
              )
            ),
            const SizedBox(height: 30),
            Container(
              child: Text(
                '$couponId',
                style: const TextStyle(
                  //color: Colors.cyan, // Change the color
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              child: Text(
                'Validity Period: $validity',
                style: const TextStyle(
                  //color: Colors.cyan, // Change the color
                  fontSize: 10, // Change the font size
                  fontWeight: FontWeight.bold, // Change the font weight                  
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              child: Text(
                'Price: RM$price',
                style: const TextStyle(
                  //color: Colors.cyan, // Change the color
                  fontSize: 10, // Change the font size
                  fontWeight: FontWeight.bold, // Change the font weight               
                ),
              ),
            ),                                    
            SizedBox(height: 70),           
            Container(
              child: ElevatedButton(
                onPressed: () {
                  //Navigator.pushReplacementNamed(context, 'qrscanner');
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const QRScanner()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFC4E2A6)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      //: const BorderSide(color: Color(0xFFC4E2A6), width: 1),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(0), //to remove the shadow
                ),
                child: const Text(
                  'Scan another coupon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )          ],
        )
      ),
    );
 }
}

