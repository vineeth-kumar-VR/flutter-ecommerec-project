import 'package:demologin/database/firestore.dart';
import 'package:demologin/pages/activate.dart';
import 'package:demologin/pages/order.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Cart"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      body: StreamBuilder(
        stream: Firestore().fetchcart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data found"));
          }

          var data = snapshot.data!;
          double subtotal = 0.0;
          int itemCount = 0; // Add this line to count total quantity

          for (var item in data) {
            int qty = item["quantity"] ?? 1;
            itemCount += qty; // Add quantity to item count

            double price = 0.0;
            if (item["price"] is String) {
              String rawPrice = item["price"];
              rawPrice = rawPrice.replaceAll(RegExp(r'[^\d.]'), '');
              price = double.tryParse(rawPrice) ?? 0.0;
            } else if (item["price"] is num) {
              price = (item["price"] as num).toDouble();
            }

            print("Item: ${item["name"]}, Price: $price, Qty: $qty");

            subtotal += price * qty;
          }

          double discount = 3;
          double delivery = 2;
          double total = subtotal - discount + delivery;

          print("Subtotal: $subtotal");

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var activate = data[index];

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
                              child: Image.network(
                                activate["image"] ?? "",
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          activate["name"] ?? "",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () async {
                                            await Firestore().deletecartitem(
                                              activate["docid"],
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Item removed from cart",
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      activate["brand"] ?? "",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${(activate["price"] ?? "0").toString()}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent,
                                          ),
                                        ),

                                        Row(
                                          children: [
                                            SizedBox(width: 3),
                                            _qtyButton(Icons.remove, () async {
                                              int currentqty =
                                                  activate["quantity"] ?? 1;

                                              if (currentqty > 1) {
                                                await Firestore()
                                                    .updatequantitycart(
                                                      activate["docid"],
                                                      currentqty - 1,
                                                    );
                                              }
                                            }),

                                            SizedBox(width: 3),
                                            Text(
                                              "${activate["quantity"] ?? 1}",
                                            ),
                                            _qtyButton(Icons.add, () async {
                                              int currentqty =
                                                  activate["quantity"] ?? 1;

                                              print(
                                                "Current Qty: $currentqty, ID: ${activate["docid"]}",
                                              );
                                              await Firestore()
                                                  .updatequantitycart(
                                                    activate["docid"],
                                                    currentqty + 1,
                                                  );
                                            }),
                                          ],
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
                ),

                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Order Summary"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Items"),
                              Text(itemCount.toString()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("SubTotal"),
                              Text("\$${subtotal.toStringAsFixed(2)}"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("Discount"), Text("\$3")],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("Delivery Charges"), Text("\$2")],
                          ),
                        ),
                        Divider(height: 0.1, color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total"),
                              Text("\$${total.toStringAsFixed(2)}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      onPressed: () async {
                        // Prepare data from cart
                        List<Map<String, dynamic>> selectedProducts =
                            data.map((item) {
                              return {
                                "name": item["name"],
                                "price": item["price"],
                                "image": item["image"],
                              };
                            }).toList();

                        // Call your Firestore function to save it to "checkout" subcollection
                        await Firestore().checkoutitem(selectedProducts);

                        // Navigate to ActivatePage (no need to pass data)
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersPage()),
                        );

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Checked Out!")));
                      },

                      child: Text(
                        "Check Out",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.teal,
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: Colors.white),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
      ),
    );
  }
}
