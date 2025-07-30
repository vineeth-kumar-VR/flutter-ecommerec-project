import 'package:demologin/database/firestore.dart';
import 'package:demologin/pages/cart.dart';
import 'package:demologin/pages/filters.dart';
import 'package:demologin/pages/particularproduct.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  final String? selectedColor;
  final double? selectedPrice;
  final String? selectedBrand;
  final String? selectedUnit;
  final String? selectedSize;
  final String? searchtexts;
  final String? searchcolor;
  final String? searchprice;
  final String? searchunit;
  final String? searchsize;
 const SearchProduct({super.key,required this.selectedColor,required this.selectedPrice,required this.selectedBrand,required this.selectedUnit,required this.selectedSize, required this.searchtexts,required this.searchcolor,required this.searchprice,required this.searchunit,required this.searchsize});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  bool hearticon = false;
  TextEditingController _searchcontroller = TextEditingController();
  String searchtext = "";
  Set<String> favouriteSet = {};

  String? selectedColor;
  double? selectedPrice;
  String? selectedBrand;
  String? selectedUnit;
String? searchText;
String? selectedSize;

  @override
  void initState() {
    super.initState();

    _searchcontroller.addListener(() {
      setState(() {

        searchtext = _searchcontroller.text.trim();
      });
    });
    selectedBrand = widget.selectedBrand;
    selectedColor = widget.selectedColor;
    selectedPrice = widget.selectedPrice;
    selectedUnit = widget.selectedUnit;
    searchtext = widget.searchtexts!;
    selectedSize = widget.selectedSize;
  }

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        elevation: 0,
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchcontroller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 5),
              prefixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
              suffixIcon: IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FiltersPage(
                        selectedColor: selectedColor,
                        selectPrice: selectedPrice,
                        selectBrand: selectedBrand,
                        selectUnit: selectedUnit,
                        searchtext: searchtext,
                        searchcolor: searchtext,
                        searchprice:searchtext,
                        searchunit: searchtext,
                        searchsize: searchtext,
                        selectSize: selectedSize,
                      ),
                    ),
                  );

                  // Handle the result when coming back from FiltersPage
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      selectedColor = result['color'];
                      selectedPrice = result['price'];
                      selectedBrand = result['brand'];
                      selectedUnit = result['unit'];
                      // _searchcontroller.clear();
                      // searchtext = "";
                    });

                  }
                },
                icon: Icon(Icons.filter_list),
              ),


              filled: true,
              fillColor: Colors.grey.shade200,
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Results for",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '"$searchtext"',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: Firestore().searchdata(
                  searchtext,
                  selectedColor: selectedColor,
                  selectedPrice: selectedPrice,
                  selectedBrand: selectedBrand,
                  selectedUnit: selectedUnit,

                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No data found"));
                  }
                  var sear = snapshot.data!;

                  return GridView.builder(
                    itemCount: sear.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 4.2,
                    ),
                    itemBuilder: (context, index) {
                      var ser = sear[index];
                      final name = ser["Name"] ?? "Unknown";
                      final image = ser["Image"] ?? "";
                      final price = ser["Price"] ?? "0";
                      final description = ser["Description"] ?? "No Description";
                      final docId = ser["docId"] ?? "";
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ParticularProduct(
                                    description: description,
                                    image: image,
                                    name: name,
                                    price: price,
                                    docId: docId,
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 130,
                                    width: double.infinity,

                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(ser["Image"] ?? ''),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () async {
                                        final isFavourited = favouriteSet
                                            .contains(ser["Name"]);

                                        if (!hearticon) {
                                          await Firestore().savefavourite(
                                            name: ser["Name"],
                                            image: ser["Image"],
                                            price: ser["Price"],
                                            docId: ser["docId"],
                                            description: ser["Description"],
                                          );
                                          setState(() {
                                            favouriteSet.add(ser["Name"]);
                                          });
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Added to Favourites",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        favouriteSet.contains(ser["Name"])
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color:
                                            favouriteSet.contains(ser["Name"])
                                                ? Colors.red
                                                : Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ser["Name"],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          ser["Price"],
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.teal,
                                              ),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {
                                                  var existingCartItems =
                                                      await Firestore()
                                                          .fetchcartOnce();

                                                  // Initialize as null
                                                  Map<String, dynamic>?
                                                  existingItem;

                                                  // Try to find existing item
                                                  for (var item
                                                      in existingCartItems) {
                                                    if (item["name"] ==
                                                        ser["Name"]) {
                                                      existingItem = item;
                                                      break;
                                                    }
                                                  }

                                                  if (existingItem != null) {
                                                    // If item exists, update the quantity
                                                    int currentQty =
                                                        existingItem["quantity"] ??
                                                        1;
                                                    await Firestore()
                                                        .updatequantitycart(
                                                          existingItem["docid"],
                                                          currentQty + 1,
                                                        );
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Item quantity updated in cart!",
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    // If item doesn't exist, add it to the cart
                                                    await Firestore().savecart(
                                                      name: ser["Name"],
                                                      image: ser["Image"],
                                                      price: ser["Price"],
                                                      description:
                                                          ser["Description"],
                                                    );
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Added to Cart",
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              CartPage(),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.shopping_cart,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            StreamBuilder<int>(
                                              stream: Firestore()
                                                  .getCartItemQuantity(
                                                    ser["Name"],
                                                  ),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SizedBox(); // or show a loader
                                                } else if (snapshot.hasError) {
                                                  return SizedBox(); // handle error gracefully
                                                } else if (!snapshot.hasData ||
                                                    snapshot.data == 0) {
                                                  return SizedBox(); // no badge if 0 quantity
                                                } else {
                                                  return Positioned(
                                                    right: -2,
                                                    top: -2,
                                                    child: Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${snapshot.data}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
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
            ),
          ),
        ],
      ),
    );
  }
}
