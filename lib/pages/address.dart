
import 'package:demologin/database/firestore.dart';
import 'package:demologin/pages/addresseditpage.dart';
import 'package:flutter/material.dart';


class AddressPage extends StatefulWidget {
  final Map<String, dynamic>? existingdata;
  final String? docId;

  const AddressPage({super.key, this.existingdata, this.docId});
  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
TextEditingController _namecontroller = TextEditingController();
TextEditingController _phonecontroller = TextEditingController();
TextEditingController _alternatephonecontroller = TextEditingController();
TextEditingController _pincodecontroller = TextEditingController();
TextEditingController _statecontroller = TextEditingController();
TextEditingController _citycontroller = TextEditingController();
TextEditingController _roadareacontroller = TextEditingController();
String _selectedaddresstype = "Home";

void dispose(){
  _namecontroller.dispose();
  _phonecontroller.dispose();
  _alternatephonecontroller.dispose();
  _pincodecontroller.dispose();
  _statecontroller.dispose();
  _citycontroller.dispose();
  _roadareacontroller.dispose();
}
  @override
  void initState() {
    super.initState();
    if (widget.existingdata != null) {
      _namecontroller.text = widget.existingdata!['name'] ?? '';
      _phonecontroller.text = widget.existingdata!['phone'] ?? '';
      _alternatephonecontroller.text = widget.existingdata!['alternatephone'] ?? '';
      _pincodecontroller.text = widget.existingdata!['pincode'] ?? '';
      _statecontroller.text = widget.existingdata!['state'] ?? '';
      _citycontroller.text = widget.existingdata!['city'] ?? '';
      _roadareacontroller.text = widget.existingdata!['roadarea'] ?? '';
      _selectedaddresstype = widget.existingdata!['addresstype'] ?? '';
    }
  }
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Add Address to Orders",style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
      ),
body: SingleChildScrollView(
  child: Padding(padding: EdgeInsets.all(15),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
name(),
      SizedBox(height: 20,),
      phone(),
      SizedBox(height: 20,),
      alterphone(),
      SizedBox(height: 20,),
      pin(),
      SizedBox(height: 20,),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state(),city()
        ],
      ),
      SizedBox(height: 20,),
      road(),
      SizedBox(height: 20,),
      typeofaddress(),
      SizedBox(height: 20,),
      addressbtn()
    ],
  ),
  ),
),
    );
  }
  Widget name(){
    return TextField(
controller: _namecontroller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 16),
          labelText: "Full Name(Required)",
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.8,color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12)
          ),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black),
        borderRadius: BorderRadius.circular(12)
        )
      ),
    );
  }
  Widget phone(){
    return TextField(
controller:  _phonecontroller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 16),
          labelText: "Phone Number(Required)",
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.8,color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)
          ),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black),
              borderRadius: BorderRadius.circular(12)
          )
      ),
    );
  }

  Widget alterphone(){
    return TextField(
controller:  _alternatephonecontroller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 16),
          labelText: "+Add Alternate Phone Number",
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.8,color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)
          ),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black),
              borderRadius: BorderRadius.circular(12)
          )
      ),
    );
  }

  Widget pin(){
    return Container(
      width: 200,
      child: TextField(
controller: _pincodecontroller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 16),
            labelText: "Pincode(Required)",
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0.8,color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12)
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(12)
            )
        ),
      ),
    );
  }

  Widget state(){
    return Container(
      width: 150,
      child: TextField(
controller: _statecontroller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 16),
            labelText: "State(Required)",
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0.8,color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12)
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(12)
            )
        ),
      ),
    );
  }
  Widget city(){
    return Container(
      width: 150,
      child: TextField(
controller:  _citycontroller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 16),
            labelText: "City(Required)",
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0.8,color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12)
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(12)
            )
        ),
      ),
    );
  }

  Widget road(){
    return
       TextField(
controller:  _roadareacontroller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 16),
            labelText: "Road Name Area(Required)",
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0.8,color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12)
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(12)
            )
        ),
      );

  }

Widget typeofaddress(){
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
Text("Type Of Address",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
SizedBox(height: 10,),
        Row(
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  _selectedaddresstype = "Home";
                });
              },
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _selectedaddresstype == "Home"?Colors.teal:Colors.black,width: 2),

                  color: _selectedaddresstype == "Home" ? Colors.teal.shade50 : Colors.transparent,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5,),

                    IconButton(onPressed: (){}, icon: Icon(Icons.home,size: 30,)),

                    Text("Home",style: TextStyle(color: Colors.black,fontSize: 18),)
                  ],
                ),
              ),
            ),
            SizedBox(width: 10,),
            GestureDetector(
              onTap: (){
                setState(() {
                  _selectedaddresstype = "Work";
                });
              },
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _selectedaddresstype == "Work"?Colors.teal:Colors.black,width: 2),
                  color: _selectedaddresstype == "Work"?Colors.teal.shade50 : Colors.transparent,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5,),

                    IconButton(onPressed: (){}, icon: Icon(Icons.work,size: 30,)),

                    Text("Work",style: TextStyle(color: Colors.black,fontSize: 18),)
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
}

Widget addressbtn(){
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton( style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: ()async{
await Firestore().saveAddressOnly(name: _namecontroller.text, phone: _phonecontroller.text, alternatePhone: _alternatephonecontroller.text, pincode: _pincodecontroller.text, state: _statecontroller.text,  city:_citycontroller.text, roadarea: _roadareacontroller.text, addresstype: _selectedaddresstype, docId: widget.docId);
_namecontroller.clear();
_roadareacontroller.clear();
_citycontroller.clear();
_statecontroller.clear();
_pincodecontroller.clear();
_alternatephonecontroller.clear();
_phonecontroller.clear();
Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressEditPage(selectedid: widget.docId)));
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Address Saved Successfully!'))
        );
      }, child: Text("Save Address",style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),)),
    );
}
}
