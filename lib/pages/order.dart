import 'package:flutter/material.dart';
import 'package:demologin/pages/activate.dart';
import 'package:demologin/pages/cancel.dart';
import 'package:demologin/pages/complete.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ This switches to the Completed tab (index 1)
  void switchToCompleteTab() {
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Orders", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          labelColor: Colors.deepPurpleAccent,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.deepPurple,
          tabs: const [
            Tab(text: "Activate"),
            Tab(text: "Completed"),
            Tab(text: "Cancel"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ActivatePage(onProceedDone: switchToCompleteTab),
          const CompletePage(),
          const CancelPage(),
        ],
      ),
    );
  }
}
