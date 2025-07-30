import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demologin/database/firestore.dart';
import 'package:flutter/material.dart';

class CancelPage extends StatefulWidget {
  const CancelPage({super.key});

  @override
  State<CancelPage> createState() => _CancelPageState();
}

class _CancelPageState extends State<CancelPage> {
  // List<Map<String, String>> cancel = [
  //   {
  //     "name": "Airpods",
  //     "price": "\$333",
  //     "image": "assets/image/airpods.jpg",
  //     "brand": "boat",
  //   },
  //   {
  //     "name": "Watch",
  //     "price": "\$40",
  //     "image": "assets/image/watches.jpg",
  //     "brand": "rolex",
  //   },
  //   {
  //     "name": "Jacket",
  //     "price": "\$430",
  //     "image": "assets/image/jacket.jpg",
  //     "brand": "puma",
  //   },
  //   {
  //     "name": "LG TV",
  //     "price": "\$330",
  //     "image": "assets/image/tv.jpg",
  //     "brand": "panasonic",
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot<Map<String,dynamic>>>>(
      stream: Firestore().fetchcancelitem(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No canceled orders found"));
        }

        var cancel = snapshot.data!;
        return ListView.builder(
          itemCount: cancel.length,
          itemBuilder: (context, index) {
            var doc = cancel[index];
            var can = doc.data();
            var name = can["name"];
            var price = can["price"];
            var imageUrl = can["image"];

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
                      )
                          : imageUrl != null && !imageUrl.startsWith("http")
                          ? Image.asset(
                        imageUrl,
                        height: 130,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 130,
                            width: 100,
                            color: Colors.grey,
                            child: Icon(Icons.broken_image),
                          );
                        },
                      )
                          : Container(
                        height: 130,
                        width: 100,
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
                            Text(
                              name ?? "Unknown",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  price ?? "\$0",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
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
      }
    );
  }
}
