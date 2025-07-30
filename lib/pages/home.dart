import 'package:demologin/database/firestore.dart';
import 'package:demologin/pages/cart.dart';
import 'package:demologin/pages/particularproduct.dart';
import 'package:demologin/pages/products.dart';
import 'package:demologin/pages/searchproduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String? selectedColor;
  final double? selectedPrice;
  final String? selectedBrand;
  final String? selectedUnit;
  final String? selectedSize;
  final String? searchtext;
  final String? searchcolor;
  final String? searchprice;
  final String? searchunit;
  final String? searchsize;
  const HomePage({super.key,this.selectedColor,this.selectedPrice,this.selectedBrand,this.selectedUnit,  this.selectedSize,required this.searchtext,required this.searchcolor,required this.searchprice,required this.searchunit,required this.searchsize,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Firestore _firestore = Firestore();
  Set<String>favouriteitems = {};
String? username;


  @override
  void initState(){
    super.initState();
    getusername();
  }

  void getusername()async{
     final user =await Firestore().fetchuser();
     setState(() {
       username = user;
     });

  }

  Widget featuresection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Features",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductPage()));
        }, child: Text("See All", style: TextStyle(color: Colors.blue)))
      ],
    );
  }
  Widget popularcontent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Most Popular",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductPage()));
        }, child: Text("See All", style: TextStyle(color: Colors.blueAccent)),
        )
      ],
    );
  }
  Widget productlist() {
    return SizedBox(
      height: 170,
      child: StreamBuilder(
        stream: Firestore().fetchdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Data Found"));
          }
          var mat = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mat.length,
            itemBuilder: (context, index) {
              var material = mat[index];
              var productname = material["docId"];
              final isfavour = favouriteitems.contains(productname);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ParticularProduct(
                        description: material["Description"],
                        image: material["Image"],
                        docId: material["docId"],
                        name: material["Name"],
                        price: material["Price"],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              height: 80,
                              width: double.infinity,
                              material["Image"],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                              onPressed: () async {
                                setState(() {
                                  favouriteitems.add(productname);
                                });

                                await Firestore().addtofavourite(material);

                                await Future.delayed(Duration(seconds: 1));
                                setState(() {
                                  favouriteitems.remove(productname);
                                });
                              },
                              icon: Icon(
                                isfavour ? Icons.favorite : Icons.favorite_border_outlined,
                                color: isfavour ? Colors.red : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          material["Name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          material["Price"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage("assets/image/boyss.jpg"),
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hello!"),
                            Text(
                              username ?? "Loading",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));
                              },
                              icon: Icon(Icons.notification_add),
                            ),
                            StreamBuilder<int>(stream: Firestore().getcartitem(), builder: (context,snapshot){
                              int itemcount = snapshot.data ?? 0;
                              if(itemcount == 0){
                                return SizedBox.shrink();
                              }
                             return Positioned(
                                 right: 6,
                                 top: 2,
                                 child: Container(
                                   padding: EdgeInsets.all(4),
                                   decoration: BoxDecoration(color: Colors.red,
                                   borderRadius: BorderRadius.circular(15)
                                   ),
constraints: BoxConstraints(
  maxHeight: 20,
  maxWidth: 30
),
                                   child: Text(itemcount.toString(),style: TextStyle(
                                     color: Colors.white,
                                     fontSize: 8,
                                   ),
                                     textAlign: TextAlign.center,),
                                 ));
                            })
                          ],

                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),

                textfield(context, widget.selectedColor, widget.selectedPrice, widget.selectedBrand, widget.selectedUnit,widget.selectedSize, widget.searchtext!,widget.searchcolor!,widget.searchprice!,widget.searchunit!,widget.searchsize!),

                SizedBox(height: 10),
                imageslider(),
                SizedBox(height: 20),
                featuresection(),
                SizedBox(height: 20),
                productlist(),
                SizedBox(height: 20),
                popularcontent(),
                SizedBox(height: 20),
                popularproduct(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
  if(index == 1){
    Navigator.push(context, MaterialPageRoute(builder: (_) => SearchProduct(selectedColor: widget.searchcolor, selectedPrice: widget.selectedPrice, selectedBrand: widget.selectedBrand, selectedUnit: widget.selectedUnit, selectedSize: widget.selectedSize, searchtexts: widget.searchtext, searchcolor: widget.searchcolor, searchprice: widget.searchprice, searchunit: widget.searchunit, searchsize: widget.searchsize)));

  }
         if (index == 2) {
            // Navigate to Cart
            Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
          }
        },
        items: [
          BottomNavigationBarItem(

            icon: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(searchtext:widget.searchtext, searchcolor: widget.searchcolor, searchprice: widget.searchprice, searchunit: widget.searchunit, searchsize: widget.searchsize)));
                },
                child: Icon(Icons.home, color: Colors.blueAccent, size: 30)),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.grey, size: 30),
            label: "Search",

          ),
          BottomNavigationBarItem(
            icon: StreamBuilder<int>(
              stream: Firestore().getcartitem(),
              builder: (context, snapshot) {
                var itemcount = snapshot.data ?? 0;
                
                return Stack(
                    children: [
                      Icon(Icons.shopping_bag, color: Colors.grey, size: 30),
                      if(itemcount > 0)
                        Positioned(
                            right:0,
                            top:0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(maxWidth: 20,maxHeight: 20),
                              child:  Text(
                                "${itemcount}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                        )
                    ]
                 );
              }
            ),
            label: "Cart",
          ),

        ],
      ),
    );
  }
}

Widget textfield(BuildContext context,
     String? selectedColor,
     double? selectedPrice,
     String? selectedBrand,
     String? selectedUnit,
    String? selectedSize,
    String searchtext,
    String searchcolor,
    String searchprice,
    String searchunit,
    String searchsize
    ) {


  return GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchProduct(selectedColor: selectedColor, selectedPrice: selectedPrice, selectedBrand: selectedBrand, selectedUnit: selectedUnit,selectedSize: selectedSize, searchtexts: searchtext,searchcolor: searchcolor,searchprice: searchprice,searchunit: searchunit,searchsize: searchsize,)));

    },
    child: AbsorbPointer(
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.search, color: Colors.grey.shade600),
          ),
          
          hintText: "Search Here",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );
}

Widget imageslider() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("ImageCarousel").snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text("No Images Found"));
      }

      List<Widget> imagewidget =
          snapshot.data!.docs.map((doc) {
            print("Docs length: ${snapshot.data!.docs.length}");

            final data = doc.data() as Map<String, dynamic>;
            final imgurl = data['Image'] ?? "";
            print(imgurl);
            return Image.network(
              imgurl,

              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, StackTrace) =>
                      Center(child: Text("No image found")),
            );
          }).toList();
      return Container(
        width: double.infinity,
        child: ImageSlideshow(
          width: double.infinity,
          height: 200,
          initialPage: 0,
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey,
          autoPlayInterval: 3000,
          isLoop: true,
          children: imagewidget,

        ),
      );
    },
  );
}







Widget popularproduct() {
  return SizedBox(
    height: 180,
    child: StreamBuilder<List<Map<String,dynamic>>>(
      stream: Firestore().fetchdata(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        if(!snapshot.hasData || snapshot.data!.isEmpty){
          return Center(child: Text("No Data Found"),);
        }
        var items = snapshot.data!;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final popular = items[index];
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ParticularProduct(description: popular["Description"], image: popular["Image"], name: popular["Name"], price: popular["Price"], docId: popular["docId"])));
              },
              child: Container(
                width: 140,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            popular['Image']!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.favorite_border, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      popular['Name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      popular['Price']!,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    ),
  );
}
