import 'package:demologin/database/firestore.dart';
import 'package:demologin/pages/address.dart';
import 'package:flutter/material.dart';

class AddressEditPage extends StatefulWidget {
  final String? selectedid;

  const AddressEditPage({super.key,required this.selectedid});

  @override
  State<AddressEditPage> createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  String? _selectedid;
  final TextEditingController _searchcontroller = TextEditingController();
  String selectedValue = '';
   // List<Map<String,dynamic>>data = [
   //   {
   //    "image":"assets/image/map.jpg",
   //   "landmark":"mainhouse",
   //     "place":"Athencode",
   //    "number":"8976889977",
   //     "address":"koikkatharai veedu athencode mankad",
   //   },
   //   {
   //     "image":"assets/image/map1.jpg",
   //     "landmark":"mainhouse",
   //     "place":"Athencode",
   //     "number":"8976889977",
   //     "address":"koikkatharai veedu athencode mankad",
   //   },
   //   {
   //     "image":"assets/image/map.jpg",
   //     "landmark":"mainhouse",
   //     "place":"Athencode",
   //     "number":"8976889977",
   //     "address":"koikkatharai veedu athencode mankad",
   //   }
   // ];
  @override
  void initState(){
    super.initState();
    _selectedid = widget.selectedid;
        _searchcontroller.addListener((){
          setState(() {

          });
        });
  }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        searchaddress(),
              SizedBox(height: 15,),
              addresslist(),
              SizedBox(height: 10,),
              addressview(),
              SizedBox(height: 20,),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget searchaddress(){
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
controller: _searchcontroller,
            onChanged: (value){
  setState(() {

  });
            },
            decoration: InputDecoration(

              labelText: "Search The Address Here",
              labelStyle: TextStyle(color: Colors.grey),
              prefixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search,color: Colors.grey,)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 2,color: Colors.grey.shade300)
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black),
            borderRadius: BorderRadius.circular(12)
            )
          ),),
        ),
        SizedBox(width: 20,),
        Container(height: 45,
          child: ElevatedButton(style: ElevatedButton.styleFrom(
            side: BorderSide(color: Colors.teal),
            foregroundColor: Colors.teal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5,),)
          ), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressPage()));
          }, child: Text("Add Address")),
        )
      ],
    );
  }

Widget addresslist(){
    return Padding(padding: EdgeInsets.all(10),
    child: Text("Address List",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
    );
}

Widget addressview(){
    return Padding(padding: EdgeInsets.all(10),
    child:
        StreamBuilder<List<Map<String,dynamic>>>(
          stream: Firestore().searchaddressdata(_searchcontroller.text),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(child: Text("No data found"),);
            }
            var serdata = snapshot.data!;


            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: serdata.length, itemBuilder: (context,index){
              var addresslist = serdata[index];
              final isselected = _selectedid == addresslist["docId"];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedid = addresslist["docId"];

                    });
                  },
                  child: Container(
                              height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1,color: isselected?Colors.teal:Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    child:
                        Column(
                          children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                              Padding(padding: EdgeInsets.all(8),
                                child: ClipRRect(borderRadius: BorderRadius.circular(20),
                                child: Image.asset(height: 100,width: 120,fit: BoxFit.cover, "assets/image/map.jpg"),
                                ),
                              ),

                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.zero,
                                    height: 30,
                                    width: 70,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                        color: Colors.teal.shade50
                                    ),
                                    child: Padding(padding: EdgeInsets.all(4), child: Center(child: Text(addresslist["addresstype"] ?? "unknown",style: TextStyle(fontSize: 12),))),
                                  ),
                                  Text(addresslist["roadarea"] ?? "unknown",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 5,),
                                  Text(addresslist["phone"] ?? "unknown"),
                                  SizedBox(height: 5,),
                                  Text(addresslist["city"] ?? "unknown",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.grey),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Radio(
                        value: addresslist["docId"],
                        groupValue: _selectedid,
                        onChanged: (value) {
                          setState(() {
                              _selectedid = value.toString();
                          });
                        },
                      ),          ],
                  ),
                              Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.21,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        backgroundColor: Colors.teal,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddressPage(
                                              existingdata: addresslist,
                                              docId: addresslist['docId'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text("Edit", style: TextStyle(color: Colors.white,fontSize: 9)),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.21,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        backgroundColor: Colors.teal,
                                      ),
                                      onPressed: () async {
                                        await Firestore().deleteaddress(addresslist['docId']);
                                      },
                                      child: Text("Delete", style: TextStyle(color: Colors.white,fontSize: 9)),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.21,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        backgroundColor: addresslist["status"] == "primary" ? Colors.red:Colors.teal
                                      ),
                                      onPressed: () async{
                                        await Firestore().getprimaryaddress(addresslist["docId"]);
                                       Navigator.pop(context,addresslist);
                                      },
                                      child: Text(addresslist["status"] == "primary" ? "unprimary":"primary", style: TextStyle(color: Colors.white,fontSize: 7)),
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),),
                ),
              );
            });
          }
        )

    );
}


}
