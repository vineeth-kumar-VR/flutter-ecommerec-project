import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demologin/database/firestore.dart';
import 'package:demologin/pages/complete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActivatePage extends StatefulWidget {
  final VoidCallback onProceedDone;

  const ActivatePage({super.key,required this.onProceedDone});

  @override
  State<ActivatePage> createState() => _ActivatePageState();
}

class _ActivatePageState extends State<ActivatePage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> activatepro = [];

  // Fetch checkout items from Firestore
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchCheckoutItems() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("checkout")
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs);
    } else {
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        stream: fetchCheckoutItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No checkout items found"));
          }

          var activatepro = snapshot.data!.where((doc) {
            return doc.data()['status'] == 'active';
          }).toList();

          return ListView.builder(
            itemCount: activatepro.length,
            itemBuilder: (context, index) {
              var doc = activatepro[index];
              var activate = doc.data();
              var docId = doc.id;

              var name = activate["name"] ?? "Unknown";
              var price = activate["price"] ?? "\$0";
              var imageUrl = activate["image"];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: imageUrl != null && imageUrl.startsWith("http")
                            ? Image.network(
                          imageUrl,
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 130,
                              width: 130,
                              color: Colors.grey,
                              child: Icon(Icons.broken_image),
                            );
                          },
                        )
                            : imageUrl != null && !imageUrl.startsWith("http")
                            ? Image.asset(
                          imageUrl,
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 130,
                              width: 130,
                              color: Colors.grey,
                              child: Icon(Icons.broken_image),
                            );
                          },
                        )
                            : Container(
                          height: 130,
                          width: 130,
                          color: Colors.grey,
                          child: Icon(Icons.broken_image),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                                      onPressed: () async{

                                        await Firestore().proceedorder(docId);
                                        await Future.delayed(Duration(seconds: 1));
                                        widget.onProceedDone();


                                      }, child: Text("Proceed",style: TextStyle(color: Colors.white),),

                                  )
                                ],
                              ),
                              SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$${price}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Cancel Order"),
                                            content: Text(
                                              "Are you sure you want to delete this order?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: ()async {

                                                  await Firestore().cancelorder(docId);

                                                  Navigator.pop(context);
                                                },
                                                child: Text("Yes"),
                                              ),
                                              TextButton(
                                                onPressed: () {

                                                  Navigator.pop(context);
                                                },
                                                child: Text("No"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
