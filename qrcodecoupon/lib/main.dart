import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(    
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mahabbah Food Coupon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List <String> entries = [];

  @override
  void initState() { //when open the app, it will get the entries from the database
    super.initState();
    getEntries();
  }

  void getEntries() async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('coupon_entries').orderBy('timestamp').get(); //it will only show data that has timestamp only
    querySnapshot.docs.forEach((doc){
        setState(() {
          entries.add(doc['text']);
        });
      }
    );
  }

  void openDialog(){
    showDialog(
      context: context,
      builder: (context){
        TextEditingController textController = TextEditingController();

        final formKey = GlobalKey<FormState>();

        return AlertDialog( //to show the dialog, return an AlertDialog
          title: const Text('Create a new coupon'),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                   autofocus: true,
                   maxLines: 4, //to make the textfield multiline
                   controller: textController,
                   validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter your coupon';
                    }
                    return null;
                  },               
                  decoration: const InputDecoration(
                  hintText: 'Dear coupon..',
                  border: OutlineInputBorder(),
                  ),
                ),                  
              ]              
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                if(formKey.currentState!.validate()){ // to call the validator
                  CollectionReference entry =
                  FirebaseFirestore.instance.collection('coupon_entries');
                  entry.add({
                    'text': textController.text,
                    'timestamp': DateTime.now()
                  });

                  setState(() {
                    entries.add(textController.text);
                  });
                  Navigator.pop(context); //to close the dialog after click save
                }
              },
              child: const Text('Save'))
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          openDialog();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.card_membership),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    
      body: Center(        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 20),

            const Text("Write your thoughts here", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Save"),
                Text("Secure"),
                Text("Private"),
              ],
            ),

            const Divider(thickness: 3, color:Colors.blue),

            const SizedBox(height: 20),

            const Text("My coupon", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            Expanded(
              child:
              ListView.builder(
                itemCount: entries.length, // to get the length of the list entries
                itemBuilder: (BuildContext context, int index){

                return GestureDetector( // to make the list item clickable
                  onTap: (){
                    print('tapped');
                  },

                  onLongPress: (){ //to delete the entry, not on firebase
                    //print('long pressed');

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text ("Confirm deletion"),
                          content: const Text("Do you want to delete this entry?"),
                          actions: [
                            TextButton(onPressed: () async {
                              Navigator.pop(context);
                            },
                              child: const Text("Cancel"), // to close the dialog                          
                            ),

                            TextButton(onPressed: () async {
                              await FirebaseFirestore.instance
                                .collection('coupon_entries')
                                .where('text', isEqualTo: entries[index])
                                .get()
                                .then((querySnapshot) {
                                  querySnapshot.docs.forEach((doc){
                                    doc.reference.delete(); // to delete the entry from firebase
                                  });
                                });

                              //delete entry from local state
                              setState(() {
                                entries.removeAt(index);
                              });

                              Navigator.pop(context); // close dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Entry deleted"),
                                ),                                
                              );
                            },
                            child: const Text("Yes"), // to close the dialog                                                                               
                            ),
                          ],
                        );
                      },
                    );                                  
                    // setState(() {
                    //   entries.removeAt(index); //to delete the entry from local state
                    // });
                  },
                  child: ListTile(
                    title: Text(entries[index]), //to show the text in the list item 
                  )
                );

                // return Container(
                //   // decoration: BoxDecoration(
                //   //   border: Border.all(
                //   //     color: Colors.blue,
                //   //   ),
                //   // ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(10.0), //spacing between each list item
                //     child: ListTile(
                //       title: Text(entries[index]),
                //     ),
                //   ),
                // );
              }),
            ),
          ],)
      ),
      
    );
  }
}
