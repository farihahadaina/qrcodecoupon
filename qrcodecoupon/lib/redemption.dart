//import 'routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'qrscanner.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(    
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
//         useMaterial3: true,
//       ),
//       home: const MyRedemption(title: 'Mahabbah Food Coupon'),
//     );
//   }
// }

class Redemption extends StatefulWidget {
  //const MyRedemption({super.key, required this.title});
  //const Redemption({Key? key, required this.couponId}) : super(key: key); // to get the coupon ID from QRScanner
  //const Redemption({Key? key, this.couponId = ''}) : super(key: key); // to get the coupon ID from QRScanner  
  //final String couponId; // to get the coupon ID from QRScanner
  const Redemption({Key? key}) : super(key: key);

  @override
  State<Redemption> createState() => _RedemptionState();  
}

class _RedemptionState extends State<Redemption> {
  String couponId = '';
  DateTime validity = DateTime.now();
  double price = 0.0;

//  @override
//  void initState() {
//     super.initState();
//     //couponId = widget.couponId; // couponId is empty string if no coupon ID is passed from QRScanner
//     final String couponId = ModalRoute.of(context)!.settings.arguments as String; // to get the coupon ID from QRScanner but it will show error if the coupon ID is empty string
//     this.couponId = couponId; 
//     redeemCoupon();
//  }

@override
  void initState() {
    super.initState();
    redeemCoupon();
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

// class _RedemptionState extends State<Redemption> {
//   //final _controller = TextEditingController();
//   String couponId = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text('Coupon redemption'), 
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Text('Enter coupon ID:'),
//             TextField(
//               controller: _controller,
//               decoration: const InputDecoration(hintText: 'Enter coupon ID'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String enteredCouponId = _controller.text;
//                 DocumentSnapshot doc = await FirebaseFirestore.instance
//                 .collection('coupon_entries')
//                 .doc(enteredCouponId)
//                 .get(); //to get the data from firebase with the entered coupon ID 
//                 if (doc.exists) {
//                  setState(() {
//                     couponId = enteredCouponId;
//                  });
//                 } else {
//                  //print('No coupon found with this ID');
//                  setState(() {
//                     couponId = 'No coupon found with this ID'; 
//                  });
//                 }
//               },
//               child: const Text('Find coupon'),
//             ),
//             Text('Coupon ID: $couponId'),
//           ],
//         ),
//       ),
//     );
//  }
// }


// class MyRedemption extends StatefulWidget {
//   const MyRedemption({super.key, required this.title});

//   final String title;

//   @override
//   State<MyRedemption> createState() => _MyRedemptionState();
// }

// class _MyRedemptionState extends State<MyRedemption> {
//   //List <String> entries = [];
//   String couponId = '';

//   @override
//   void initState() { //when open the app, it will get the entries from the database
//     super.initState();
//     //getEntries();
//     couponId = ModalRoute.of(context)!.settings.arguments as String;
//   }

//   Future<void> addEntry(String text) async {
//     // Get the last used ID from a separate document
//     DocumentSnapshot counterSnap = await FirebaseFirestore.instance.doc('counters/coupon').get();
//     Map<String, dynamic>? counterData = counterSnap.data() as Map<String, dynamic>?;
//     int lastId = counterData != null ? counterData['lastId'] : 0;

//     // Generate new ID
//     String newId = 'M' + (lastId + 1).toString().padLeft(4, '0');

//     // Update the counter document with the new last used ID
//     await FirebaseFirestore.instance.doc('counters/coupon').update({'lastId': lastId + 1});

//     // Add the new entry with the new ID
//     await FirebaseFirestore.instance.collection('coupon_entries').doc(newId).set({'text': text, 'timestamp': Timestamp.now()});
//   }

//   // void getEntries() async{
//   //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('coupon_entries').orderBy('timestamp').get(); //it will only show data that has timestamp only
//   //   querySnapshot.docs.forEach((doc){
//   //       setState(() {
//   //         entries.add(doc['text']);
//   //       });
//   //     }
//   //   );
//   // }

//   // void openDialog(){
//   //   showDialog(
//   //     context: context,
//   //     builder: (context){
//   //       TextEditingController textController = TextEditingController();

//   //       final formKey = GlobalKey<FormState>();

//   //       return AlertDialog( //to show the dialog, return an AlertDialog
//   //         title: const Text('Create a new coupon'),
//   //         content: Form(
//   //           key: formKey,
//   //           child: Column(
//   //             children: [
//   //               TextFormField(
//   //                  autofocus: true,
//   //                  maxLines: 4, //to make the textfield multiline
//   //                  controller: textController,
//   //                  validator: (value) {
//   //                   if(value == null || value.isEmpty){
//   //                     return 'Please enter your coupon';
//   //                   }
//   //                   return null;
//   //                 },               
//   //                 decoration: const InputDecoration(
//   //                 hintText: 'Dear coupon..',
//   //                 border: OutlineInputBorder(),
//   //                 ),
//   //               ),                  
//   //             ]              
//   //           ),
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: (){
//   //               if(formKey.currentState!.validate()){ // to call the validator
//   //                 CollectionReference entry =
//   //                 FirebaseFirestore.instance.collection('coupon_entries');
//   //                 entry.add({
//   //                   'text': textController.text,
//   //                   'timestamp': DateTime.now()
//   //                 });

//   //                 setState(() {
//   //                   entries.add(textController.text);
//   //                 });
//   //                 Navigator.pop(context); //to close the dialog after click save
//   //               }
//   //             },
//   //             child: const Text('Save'))
//   //         ],
//   //       );
//   //     }
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
      
//       // floatingActionButton: Padding(
//       //   padding: const EdgeInsets.only(right: 20.0),
//       //   child: Row(
//       //     crossAxisAlignment: CrossAxisAlignment.end,
//       //     children: [
//       //       FloatingActionButton(
//       //         onPressed: () {
//       //           openDialog();
//       //           Navigator.push(
//       //             context,
//       //             MaterialPageRoute(builder: (context) => const QRScanner()),
//       //           );
//       //         },
//       //         tooltip: 'QR Scanner',
//       //         child: const Icon(Icons.qr_code_scanner),
//       //       ),
//       //       const SizedBox(width: 16),
//       //       FloatingActionButton(
//       //         onPressed: () {
//       //           // Handle onPressed for the card membership icon if needed
//       //         },
//       //         tooltip: 'Card Membership',
//       //         child: const Icon(Icons.card_membership),
//       //       ),
//       //     ],
//       //   ),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
    
//       // body: Center(        
//       //   child: Column(
//       //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //     children: [
//       //       const SizedBox(height: 20),

//       //       const Text("Write your thoughts here", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

//       //       const SizedBox(height: 20),

//       //       const Row(
//       //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //         children: [
//       //           Text("Save"),
//       //           Text("Secure"),
//       //           Text("Private"),
//       //         ],
//       //       ),

//       //       const Divider(thickness: 3, color:Colors.blue),

//       //       const SizedBox(height: 20),

//       //       const Text("My coupon", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

//       //       Expanded(
//       //         child:
//       //         ListView.builder(
//       //           itemCount: entries.length, // to get the length of the list entries
//       //           itemBuilder: (BuildContext context, int index){

//       //           return GestureDetector( // to make the list item clickable
//       //             onTap: (){
//       //               print('tapped');
//       //             },

//       //             onLongPress: (){ //to delete the entry, not on firebase
//       //               //print('long pressed');

//       //               showDialog(
//       //                 context: context,
//       //                 builder: (context) {
//       //                   return AlertDialog(
//       //                     title: const Text ("Confirm deletion"),
//       //                     content: const Text("Do you want to delete this entry?"),
//       //                     actions: [
//       //                       TextButton(onPressed: () async {
//       //                         Navigator.pop(context);
//       //                       },
//       //                         child: const Text("Cancel"), // to close the dialog                          
//       //                       ),

//       //                       TextButton(onPressed: () async {
//       //                         await FirebaseFirestore.instance
//       //                           .collection('coupon_entries')
//       //                           .where('text', isEqualTo: entries[index])
//       //                           .get()
//       //                           .then((querySnapshot) {
//       //                             querySnapshot.docs.forEach((doc){
//       //                               doc.reference.delete(); // to delete the entry from firebase
//       //                             });
//       //                           });

//       //                         //delete entry from local state
//       //                         setState(() {
//       //                           entries.removeAt(index);
//       //                         });

//       //                         Navigator.pop(context); // close dialog
//       //                         ScaffoldMessenger.of(context).showSnackBar(
//       //                           const SnackBar(
//       //                             content: Text("Entry deleted"),
//       //                           ),                                
//       //                         );
//       //                       },
//       //                       child: const Text("Yes"), // to close the dialog                                                                               
//       //                       ),
//       //                     ],
//       //                   );
//       //                 },
//       //               );                                  
//       //               // setState(() {
//       //               //   entries.removeAt(index); //to delete the entry from local state
//       //               // });
//       //             },
//       //             child: ListTile(
//       //               title: Text(entries[index]), //to show the text in the list item 
//       //             )
//       //           );

//       //           // return Container(
//       //           //   // decoration: BoxDecoration(
//       //           //   //   border: Border.all(
//       //           //   //     color: Colors.blue,
//       //           //   //   ),
//       //           //   // ),
//       //           //   child: Padding(
//       //           //     padding: const EdgeInsets.all(10.0), //spacing between each list item
//       //           //     child: ListTile(
//       //           //       title: Text(entries[index]),
//       //           //     ),
//       //           //   ),
//       //           // );
//       //         }),
//       //       ),
//       //     ],)
//       // ),

//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text('Successfully redeemed coupon: $couponId'),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, Routes.qrscanner);
//               },
//               child: Text('Scan another coupon'),
//             ),
//           ],
//         ))      
//     );
//   }
// }