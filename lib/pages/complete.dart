import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demologin/database/firestore.dart';
import 'package:flutter/material.dart';

class CompletePage extends StatefulWidget {
  const CompletePage({super.key});

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<QueryDocumentSnapshot<Map<String,dynamic>>>>(
        stream: Firestore().fetchproceedorder(),
        builder: (context, snapshot) {
      
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return Center(child: Text("No Data Found"),);
          }
          final order = snapshot.data!;
          return ListView.builder(
            itemCount: order.length,
            itemBuilder: (context,index){
              var item  = order[index];
              var docId = item.id;
              return Padding(padding: EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.teal,width: 2),
            borderRadius: BorderRadius.circular(10),

          ),
                child: Padding(padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(

                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            width: 150,
                            height: 100,
                            item["image"]!,
                          fit: BoxFit.cover,
                          ),

                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(item["name"],style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                                  Text(item["price"],style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)
                                ],
                              ),

                          ),
                        )


                      ],
                    ),
                    SizedBox(height: 10,),
                    StreamBuilder<Map<String,dynamic>>(stream: Firestore().addressshow(), builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }
                      if(!snapshot.hasData || snapshot.data!.isEmpty){
                        return Center(child: Text("No Address Found"),);
                      }
                      var addressitem = snapshot.data!;
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          borderRadius: BorderRadius.circular(10),

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                          Text("Name:${addressitem["name"]}"),
                              Text("Phone:${addressitem["phone"]}"),
                              Text("Pincode:${addressitem["pincode"]}"),
                              Text("City:${addressitem["city"]}"),

                              SizedBox(height: 10,),
                              Padding(padding: EdgeInsets.all(8),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                                  onPressed: ()async{
                                    bool confirm = await showDialog(context: context, builder: (context)=>AlertDialog(
                                      title: Text("Cancel Order"),
                                      content: Text("Are you sure you want to cancel this order?"),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Navigator.pop(context,false);
                                        }, child: Text("No")),
                                        TextButton(onPressed: (){
                                          Navigator.pop(context,true);
                                        }, child: Text("Yes"))
                                      ],
                                    )

                                    );
if(confirm == true){
  await Firestore().deleteorder(docId);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Order cancelled")),
  );
}
                                  }, child: Text("Cancel Order",style: TextStyle(color: Colors.white),)),
                              )

                            ],
                          ),
                        ),
                      );
                    })
                  ],
                ),
                ),
              ),
              );
            },
          );
        }
      ),
    );
  }
}
