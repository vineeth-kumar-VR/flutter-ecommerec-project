import 'package:demologin/pages/addresseditpage.dart';
import 'package:demologin/pages/checkout.dart';
import 'package:flutter/material.dart';

class AddressAndBillingTabs extends StatefulWidget {
  const AddressAndBillingTabs({super.key});

  @override
  State<AddressAndBillingTabs> createState() => _AddressAndBillingTabsState();
}

class _AddressAndBillingTabsState extends State<AddressAndBillingTabs> {
  String? selectedid;
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)), title: Text("Address"),

      ),
      body: Column(
        children: [
          TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.teal,
            tabs: [
              Tab(text: "Shipping Address",),
              Tab(text: "Billing",)
            ],
          ),
          Expanded(child: TabBarView(children: [
            AddressEditPage(selectedid: selectedid),
            CheckOut()
          ]))
        ],
      ),
    ));
  }
}
