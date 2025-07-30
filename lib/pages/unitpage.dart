import 'package:demologin/database/firestore.dart';
import 'package:demologin/pages/searchproduct.dart';
import 'package:flutter/material.dart';

class UnitPage extends StatefulWidget {
  final Function(String)isselectunit;
  final String?selectunit;
  final String searchunit;

  const UnitPage({super.key,required this.isselectunit,required this.selectunit,  required this.searchunit // Receive color
    });

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  List<String>unit = [];
  bool ishover = false;
  String? _selectunit;

  @override

  void initState(){
    super.initState();
    _selectunit = widget.selectunit;
    fetchunit();
  }
  Future<void>fetchunit()async{

    final data = await Firestore().fetchunitonly(widget.searchunit);

    setState(() {
      unit = data;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: unit.isEmpty?Center(child: CircularProgressIndicator(color: Colors.white,),):Column(
        children: [
          Expanded(
            child: ListView.builder(itemCount: unit.length, itemBuilder: (context,index){
              var units = unit[index];
              return Padding(padding: EdgeInsets.all(12),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Unit:${units}",style: TextStyle(color: Colors.white,fontSize: 18),),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectunit = units;
                        widget.isselectunit(units);
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2,color: Colors.white),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(child:_selectunit == units?Icon(Icons.check,color: Colors.white,):null,),
                    ),
                  ),

                ],
              ),
              );
            }),
          ),

        ],
      ),
    );
  }
}
