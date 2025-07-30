import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> savedata(String username, String email, String uid) async {
    try {
      await _firebaseFirestore.collection("users").doc(uid).set({
        "username": username,
        "email": email,
        "uid": uid,
        "Time": DateTime.now(),
      });
    } catch (e) {
      print("error $e");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchdata() {
    return _firebaseFirestore
        .collection("ProductList")
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data["docId"] = doc.id;

            return data;
          }).toList(),
    );
  }


  Future<void> savefavourite({
    required String name,
    required String image,
    required String price,
    required String description,
    required String docId
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseFirestore
            .collection("users")
            .doc(user.uid)
            .collection("favourites")
            .add({
          "name": name,
          "image": image,
          "price": price,
          "docId": docId,
          "description": description,
          "timestamp": FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error saving favorite: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getfavourites() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .collection("favourites")
          .snapshots()
          .map(
            (snapshot) =>
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList(),
      );
    } else {
      return Stream.value([]);
    }
  }

  // Stream<List<Map<String, dynamic>>> searchdata(String searchtext) {
  //   if (searchtext.isEmpty) {
  //     return _firebaseFirestore
  //         .collection("ProductList")
  //         .snapshots()
  //         .map(
  //           (snapshot) =>
  //               snapshot.docs
  //                   .map((doc) => doc.data() as Map<String, dynamic>)
  //                   .toList(),
  //         );
  //   }
  //
  //   return _firebaseFirestore
  //       .collection("ProductList")
  //       .where("Name", isGreaterThanOrEqualTo: searchtext)
  //       .where("Name", isLessThanOrEqualTo: searchtext + '\uf8ff')
  //       .snapshots()
  //       .map(
  //         (snapshot) =>
  //             snapshot.docs
  //                 .map((doc) => doc.data() as Map<String, dynamic>)
  //                 .toList(),
  //       );
  // }
  Stream<List<Map<String, dynamic>>> searchdata(String searchtext, {
    String? selectedColor,
    double? selectedPrice,
    String? selectedBrand,
    String? selectedUnit,
  }) {
    print("Querying with Search Text: $searchtext");

    // Step 1: Basic name search (do not add brand here)
    var query = FirebaseFirestore.instance
        .collection('ProductList')
        .where('Name', isGreaterThanOrEqualTo: searchtext)
        .where('Name', isLessThanOrEqualTo: searchtext + '\uf8ff');

    // Step 3: Filter everything else manually in Dart
    return query.snapshots().asyncMap((snapshot) async {
      List<Map<String, dynamic>> allProducts = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // ✅ Filter by brand (in Dart)
      if (selectedBrand != null && selectedBrand.isNotEmpty) {
        allProducts = allProducts.where((product) {
          var brand = (product['Brand'] as String).toLowerCase();
          return brand == selectedBrand.toLowerCase();
        }).toList();
        print("Filtered by Brand: $selectedBrand");
      }

      // ✅ Filter by color
      if (selectedColor != null && selectedColor.isNotEmpty) {
        allProducts = allProducts.where((product) {
          var productColor = (product['Color'] as String).toLowerCase();
          return productColor == selectedColor.toLowerCase();
        }).toList();
        print("Filtered by Color: $selectedColor");
      }

      // ✅ Filter by price
      if (selectedPrice != null) {
        allProducts = allProducts.where((product) {
          var priceString = product['Price'] as String;
          var price = double.tryParse(priceString.replaceAll('\$', '')) ??
              0.0; // Remove '$' and parse

          return (price - selectedPrice).abs() <
              0.01; // Adding tolerance for small differences
        }).toList();
        print("Filtered by Price: == $selectedPrice");
      }
      if (selectedUnit != null && selectedUnit.isNotEmpty) {
        allProducts = allProducts.where((product) {
          var unit = (product['Unit'] as String).toLowerCase();
          return unit == selectedUnit.toLowerCase();
        }).toList();
        print("Filtered by Unit: $selectedUnit");
      }

      print("Final filtered count: ${allProducts.length}");
      return allProducts;
    });
  }


  Future<List<String>> fetchbrandonly(String searchtext) async {
    var snapshot = await _firebaseFirestore.collection("ProductList").where(
        "Name", isGreaterThanOrEqualTo: searchtext).where(
        "Name", isLessThanOrEqualTo: searchtext + '\uf8ff').get();
    Set<String>brands = {};
    for (var selebrand in snapshot.docs) {
      var brand = selebrand["Brand"];
      if (brand != null) {
        brands.add(brand);
      }
    }
    return brands.toList();
  }

  Future<List<String>> fetchcoloronly(String searchcolor) async {
    QuerySnapshot snapshot;

    if (searchcolor
        .trim()
        .isEmpty) {
      // Fetch all products if no search text
      snapshot = await _firebaseFirestore.collection("ProductList").get();
    } else {
      snapshot = await _firebaseFirestore
          .collection("ProductList")
          .where("Name", isGreaterThanOrEqualTo: searchcolor)
          .where("Name", isLessThanOrEqualTo: searchcolor + '\uf8ff')
          .get();
    }

    Set<String> colors = {};

    for (var selecolor in snapshot.docs) {
      var color = selecolor["Color"];
      if (color != null && color
          .toString()
          .trim()
          .isNotEmpty) {
        colors.add(color.toString().trim());
      }
    }

    return colors.toList();
  }

  Future<List<String>> fetchpriceonly(String searchprice) async {
    QuerySnapshot snapshot;

    if (searchprice
        .trim()
        .isEmpty) {
      snapshot = await _firebaseFirestore.collection("ProductList").get();
    } else {
      snapshot = await _firebaseFirestore
          .collection("ProductList")
          .where("Name", isGreaterThanOrEqualTo: searchprice)
          .where("Name", isLessThanOrEqualTo: searchprice + '\uf8ff')
          .get();
    }

    Set<String> prices = {};
    for (var doc in snapshot.docs) {
      var priceStr = doc["Price"];
      if (priceStr != null && priceStr
          .toString()
          .isNotEmpty) {
        final clean = priceStr.toString().replaceAll(RegExp(r'[^\d.]'), '');
        prices.add(clean);
      }
    }

    print("🔍 Search text: '$searchprice'");
    print("✅ Filtered prices: $prices");

    return prices.toList();
  }

  Future<List<String>> fetchunitonly(String searchunit) async {
    QuerySnapshot snapshot;
    if (searchunit
        .trim()
        .isEmpty) {
      snapshot = await _firebaseFirestore.collection("ProductList").get();
    }
    else {
      snapshot = await _firebaseFirestore.collection("ProductList").where(
          "Name", isGreaterThanOrEqualTo: searchunit).where(
          "Name", isLessThanOrEqualTo: searchunit + '\uf8ff').get();
    }
    Set<String>units = {};
    for (var seleunit in snapshot.docs) {
      if (seleunit.data().toString().contains("Unit")) {
        var unit = seleunit["Unit"];
        if (unit != null && unit
            .toString()
            .isNotEmpty) {
          units.add(unit);
        }
        else {
          print("Print id: ${seleunit.id}");
        }
      }
    }
    return units.toList();
  }

  Future<List<String>> fetchsizeonly(String searchsize) async {
    QuerySnapshot snapshot;
    if (searchsize
        .trim()
        .isEmpty) {
      snapshot = await _firebaseFirestore.collection("ProductList").get();
    }
    else {
      snapshot = await _firebaseFirestore.collection("ProductList").where(
          "Name", isGreaterThanOrEqualTo: searchsize).where(
          "Name", isLessThanOrEqualTo: searchsize + '\uf8ff').get();
    }
    Set<String>sizes = {};
    for (var selesize in snapshot.docs) {
      if (selesize.data().toString().contains("Size")) {
        var size = selesize["Size"];
        if (size != null && size
            .toString()
            .isNotEmpty) {
          sizes.add(size);
        }
      }
    }
    return sizes.toList();
  }


  Future<void> savecart({
    required String name,
    required String image,
    required String price,
    required String description,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseFirestore
            .collection("users")
            .doc(user.uid)
            .collection("cart")
            .add({
          "name": name,
          "image": image,
          "price": price,
          "description": description,
          "Time": DateTime.now(),
        });
      }
    } catch (e) {
      print("error adding cart $e");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchcart() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("cart")
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data["docid"] = doc.id;
          return data;
        }).toList();
      });
    } else {
      return Stream.value([]);
    }
  }

  Future<void> updatequantitycart(String docid, int newQty) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = _firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .collection("cart")
          .doc(docid);

      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        String priceStr = data["price"] ?? "\$0";
        int oldQty = data["quantity"] ?? 1;
        // Get unit price by dividing old price by old quantity
        double unitPrice = double.tryParse(priceStr.replaceAll("\$", "")) ?? 0;
        if (oldQty > 0) {
          unitPrice = unitPrice / oldQty;
        }
        double newTotalPrice = unitPrice * newQty;
        await docRef.update({
          "quantity": newQty,
          "price": "\$${newTotalPrice.toStringAsFixed(2)}",
        });
      }
    }
  }

  Future<void> deletecartitem(String docid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .collection("cart")
          .doc(docid)
          .delete();
    }
  }

  Future<List<Map<String, dynamic>>> fetchcartOnce() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(user.uid)
            .collection("cart")
            .get();
        // Map each document to include its data + docid
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data["docid"] = doc.id;
          return data;
        }).toList();
      }
    } catch (e) {
      print("Error fetching cart: $e");
    }
    return [];
  }

  Stream<int> getCartItemQuantity(String productName) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(0);
    }
    return _firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .collection("cart")
        .where("name", isEqualTo: productName)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return data["quantity"] ?? 0;
      } else {
        return 0;
      }
    });
  }

  Future<void> checkoutitem(List<Map<String, dynamic>> products) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snap = await _firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .collection("checkout");
      for (var product in products) {
        await snap.add({
          "name": product["name"],
          "price": product["price"],
          "image": product["image"],
          'timestamp': FieldValue.serverTimestamp(),
          'status': "active"
        });
      }
      print("Checkout items added successfully!");
    } else {
      print("no user signed in");
    }
  }

  Future<void> cancelorder(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("checkout")
            .doc(docId)
            .update({
          "status": "cancel", // Update status to 'cancel'
        });
        print("Order status updated to cancel");
      } catch (e) {
        print("Error updating order status: $e");
      }
    } else {
      print("No user signed in");
    }
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchcancelitem() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _firebaseFirestore.collection("users").doc(user.uid).collection(
          "checkout").where("status", isEqualTo: "cancel").snapshots().map((
          snapshot) => snapshot.docs.toList());
    }
    else {
      return Stream.empty();
    }
  }

  Future<void> saveAddressOnly({
    required String name,
    required String phone,
    required String alternatePhone,
    required String pincode,
    required String state,
    required String city,
    required String roadarea,
    required String addresstype,
    bool setasprimary = false,
    String? docId,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final addressRef = _firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .collection("addressdata");
      if (setasprimary) {
        final existingprimary = await addressRef.where(
            "status", isEqualTo: "primary").get();

        for (var doc in existingprimary.docs) {
          await addressRef.doc(doc.id).update({"status": "secondary"});
        }
      }
      final data = {
        "name": name,
        "phone": phone,
        "alternatephone": alternatePhone,
        "pincode": pincode,
        "state": state,
        "city": city,
        "roadarea": roadarea,
        "addresstype": addresstype,
        "status": setasprimary ? "primary" : "secondary",
        docId == null ? "createdAt" : "updatedAt": FieldValue.serverTimestamp(),
      };
      if (docId != null) {
        await addressRef.doc(docId).update(data);
      }
      else {
        await addressRef.add(data);
      }
    }
  }

  Stream<List<Map<String, dynamic>>> searchaddressdata(String searchaddress) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final query = _firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .collection("addressdata");

      if (searchaddress.isEmpty) {
        return query.snapshots().map(
              (snapshot) =>
              snapshot.docs
                  .map((doc) =>
              {
                ...doc.data(),
                'docId': doc.id, // Attach docId
              })
                  .toList(),
        );
      } else {
        return query
            .where(
            'roadarea', isGreaterThanOrEqualTo: searchaddress.toLowerCase())
            .where('roadarea',
            isLessThanOrEqualTo: searchaddress.toLowerCase() + '\uf8ff')
            .snapshots()
            .map(
              (snapshot) =>
              snapshot.docs
                  .map((doc) =>
              {
                ...doc.data(),
                'docId': doc.id, // Attach docId
              })
                  .toList(),
        );
      }
    } else {
      return Stream.value([]);
    }
  }

  Future<void> deleteaddress(String docid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firebaseFirestore.collection("users").doc(user.uid).collection(
          "addressdata").doc(docid).delete();
    }
  }

  Future<void> getprimaryaddress(String selecteddocid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final addressref = await _firebaseFirestore.collection("users").doc(
          user.uid).collection("addressdata");

      final snapshot = await addressref.get();

      for (var doc in snapshot.docs) {
        final newdata = doc.id == selecteddocid ? "primary" : "secondary";
        await addressref.doc(doc.id).update({"status": newdata});
      }
    }
  }

  Stream<Map<String, dynamic>> addressshow() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _firebaseFirestore.collection("users").doc(user.uid).collection(
          "addressdata").where("status", isEqualTo: "primary").snapshots().map((
          snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.data();
        }
        else {
          return {};
        }
      });
    }
    else {
      return Stream.empty();
    }
  }

  Future<List<double>> getprice() async {
    final snapshot = await _firebaseFirestore.collection("ProductList").get();
    final snap = await snapshot.docs.map((data) {
      final dataprice = data["Price"] as String;
      final changeprice = dataprice.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(changeprice) ?? 0.0;
    }).toSet().toList();
    return snap;
  }


  Future<List<String>> getunit() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection(
          "ProductList").get();
      final units = snapshot.docs
          .map((doc) => doc.data()["Unit"]?.toString().toLowerCase())
          .where((unit) => unit != null && unit.isNotEmpty)
          .toSet()
          .toList();
      return units.cast<String>();
    } catch (e) {
      print("Error fetching units: $e");
      return [];
    }
  }

  Stream<DocumentSnapshot?> fetchbysize(String name, String size) {
    return _firebaseFirestore
        .collection("ProductList")
        .where(
        "Name", isEqualTo: name)
        .where("Size", isEqualTo: size)
        .limit(1)
        .snapshots()
        .map((snapshot) =>
    snapshot.docs.isNotEmpty
        ? snapshot.docs.first
        : null);
  }

  Future<void> saveToCart(Map<String, dynamic> productData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartRef = _firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .collection("cart");

// Optionally: check if item with same name already exists
    final query = await cartRef
        .where("name", isEqualTo: productData["name"])
        .get();

    if (query.docs.isNotEmpty) {
// Already in cart — update quantity
      final existingDoc = query.docs.first;
      int existingQty = existingDoc["quantity"] ?? 1;
      int newQty = existingQty + 1;
      double unitPrice = double.tryParse(
        productData["price"].toString().replaceAll("\$", ""),
      ) ?? 0;

      double newTotalPrice = unitPrice * newQty;

      await existingDoc.reference.update({
        "quantity": newQty,
        "price": "\$${newTotalPrice.toStringAsFixed(2)}",
      });
    } else {
// Not in cart — add new
      await cartRef.add(productData);
    }
  }

  Future<void> proceedorder(String docId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docref = FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("checkout")
          .doc(docId);

      final snapshot = await docref.get();
      if (snapshot.exists && snapshot.data()?["status"] == "active") {
        await docref.update({
          "status": "proceed",
          "timestamp": FieldValue.serverTimestamp(),
        });
        print("✅ Status changed to proceed for $docId");
      } else {
        print("❌ Status not active or doc missing");
      }
    }
  }

Stream<List<QueryDocumentSnapshot<Map<String,dynamic>>>>fetchproceedorder(){
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      return FirebaseFirestore.instance.collection("users").doc(user.uid).collection("checkout").where("status",isEqualTo: "proceed").snapshots().map((snapshot){
        return snapshot.docs;
      });
    }
    else{
      return Stream.empty();
    }
}

Future<void>deleteorder(String docId)async{
final user = FirebaseAuth.instance.currentUser;
if(user!=null){
  return await _firebaseFirestore.collection("users").doc(user.uid).collection("checkout").doc(docId).delete();
}
  }

  Stream<int>getcartitem(){
    final user = FirebaseAuth.instance.currentUser;
    if(user == null){
      return Stream.value(0);
    }
    return _firebaseFirestore.collection("users").doc(user.uid).collection("cart").snapshots().map((snapshot)=>snapshot.docs.length);
  }
  
  Stream<List<Map<String,dynamic>>>fetchproduct(){
    return _firebaseFirestore.collection("ProductList").snapshots().map((snapshot)=>snapshot.docs.map((docs){
      var data = docs.data();
      data["docId"] = docs.id;
      return data;
    }).toList());
  }
  Future<void>addtofavourite(Map<String,dynamic>products)async{
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      final addproduct = await _firebaseFirestore.collection("users").doc(user.uid).collection("favourites");

      await addproduct.add({
        "Name":products["Name"],
        "Price":products["Price"],
        "Image":products["Image"],
        "Description":products["Description"]

      });
    }
  }
Future<String?>fetchuser()async{
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      final doc = await _firebaseFirestore.collection("users").doc(user.uid).get();
      if(doc.exists){
        return doc.data()?["username"] ?? "User";
      }
    }
}
}