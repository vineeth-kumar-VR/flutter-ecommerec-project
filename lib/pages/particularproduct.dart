import 'package:demologin/database/firestore.dart';
import 'package:demologin/pages/addresseditpage.dart';
import 'package:demologin/pages/cart.dart';
import 'package:flutter/material.dart';


class ParticularProduct extends StatefulWidget {
  final String description;
  final String image;
  final String name;
  final String price;
  final String docId;

  const ParticularProduct({
    super.key,
    required this.description,
    required this.image,
    required this.name,
    required this.price,
    required this.docId
  });

  @override


  State<ParticularProduct> createState() => _ParticularProductState();
}

class _ParticularProductState extends State<ParticularProduct> {
  bool hearticon = false;
List<String>availablesize = [];
  String selectedsize = "";
  String currentimage = "";
  String currentprice = "";
  String currentdescription = "";
  String currentid = "";


  @override
  void initState(){
    super.initState();
    currentimage = widget.image;
    currentprice = widget.price;
    currentdescription = widget.description;
    currentid = widget.docId;

    if(widget.name.toLowerCase() == "shoes"){
      availablesize =  ["8", "9", "10", "12"];
    }
    else{
      availablesize = [];
    }
  }

  void fetchsizedata(String size){
    Firestore().fetchbysize(widget.name, size).listen((snapshot){
if(snapshot!=null && snapshot.exists){
  final data = snapshot.data() as Map<String,dynamic>;
  final docId = snapshot.id;
  setState(() {
    selectedsize = size;
    currentimage = data["Image"] ?? widget.image;
    currentprice = data["Price"] ?? widget.price;
    currentdescription = data["Description"] ?? widget.description;
    currentid = docId;
  });
}
    });
  }


  Widget addresssection() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.teal),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: StreamBuilder<Map<String, dynamic>>(
            stream: Firestore().addressshow(),
            builder: (context, snapshot) {
              String addressText = "no address found";

              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                var data = snapshot.data!;
                addressText =
                "${data["roadarea"] ?? ""} ${data["city"] ?? ""} ${data["state"] ?? ""} ${data["pincode"] ?? ""}";
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      addressText,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddressEditPage(selectedid: widget.docId),
                        ),
                      );
                    },
                    child: Text(
                      "Change Address",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget size(String text) {
    bool isselect = selectedsize == text;

    return GestureDetector(
      onTap: () {
        fetchsizedata(text);
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: isselect ? Colors.teal : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isselect ? Colors.teal.shade100 : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isselect ? Colors.teal : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget btn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  await Firestore().saveToCart({
                    "name": widget.name,
                    "image": currentimage,
                    "price": currentprice,
                    "quantity": 1,
                    "docid": currentid,
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },

                child: Text(
                  "Buy Now",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: ClipRRect(
                    child: Image.network(currentimage, fit: BoxFit.cover),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 80,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 80,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          hearticon = !hearticon;
                        });
                        if (hearticon) {
                          await Firestore().savefavourite(
                            name: widget.name,
                            image: widget.image,
                            price: widget.price,
                            description: widget.description,
                            docId: widget.docId
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Favourites Addes Successfully"),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        hearticon
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color:
                            hearticon
                                ? Colors.red
                                : Colors.white, // Change color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
               currentprice,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 30),
                  SizedBox(width: 4),
                  Text("4.5", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("(20 Review)", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  currentdescription,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.description,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ),
addresssection(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Size",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            if (availablesize.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,

                ),
              ),
              Row(
                children: availablesize.map((sz) => size(sz)).toList(),
              ),
            ],



            btn(context),
          ],
        ),
      ),
    );
  }
}



