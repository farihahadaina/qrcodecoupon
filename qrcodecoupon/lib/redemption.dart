import 'package:flutter/material.dart';
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
 int price = 0;

 @override
 void didChangeDependencies() {
    super.didChangeDependencies();
    final String couponId =
        ModalRoute.of(context)!.settings.arguments as String;
    this.couponId = couponId;
 }

 Future<void> redeemCoupon() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('coupon_entries')
        .doc(couponId)

        .update({'isRedeemed': true});
      setState(() {
        couponId = couponId;

        validity = (doc.get('validity') as Timestamp).toDate();
        price = doc.get('price');
      });
    } else {
      couponId = 'No coupon found with this ID';
    }
  }

 @override
 Widget build(BuildContext context) {
    return FutureBuilder(
      future: redeemCoupon(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: const Text('Mahabbah Food Coupon'),
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 20
                ),                
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScanner()),
                  );
                },
              ),              
            ),
            body: Center(
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
                 Container(
                    child: const Text(
                      'Successfully redeemed!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                 ),
                 const SizedBox(height: 30),
                 Container(
                    child: Text(
                      '$couponId',
                      style: const TextStyle(
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                 ),
                 const SizedBox(height: 10),
                 Container(
                    child: Text(
                      'Price: RM$price',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                 ), 
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
