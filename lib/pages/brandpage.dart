import 'package:demologin/database/firestore.dart';
import 'package:flutter/material.dart';

class BrandPage extends StatefulWidget {
  final Function(String) isselectbrand;
  final String? selectbrand;
  final String searchtext;
  const BrandPage({super.key,required this.isselectbrand,required this.selectbrand,required this.searchtext});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  List<String>brand = [];
  String? _selectbrand;

  @override
  void initState(){
    super.initState();
    _selectbrand = widget.selectbrand;
    fetchbrand();
  }
  Future<void>fetchbrand()async{
    final data = await Firestore().fetchbrandonly(widget.searchtext);
    setState(() {
      brand = data;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body:brand.isEmpty?Center(child: CircularProgressIndicator(color: Colors.white,),):ListView.builder(itemCount: brand.length, itemBuilder: (context,index){

        var brands = brand[index];
        return Padding(padding: EdgeInsets.all(12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Brand: ${brands}",style: TextStyle(color: Colors.white,fontSize: 18),),
            GestureDetector(
              onTap: (){
                setState(() {
                  _selectbrand = brands;
                  widget.isselectbrand(brands);
                });

              },
              child: Container(
                child: Center(child:_selectbrand == brands?Icon(Icons.check,color:Colors.white):null,),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1,color: Colors.white)
                ),
              ),
            )
          ],
        ),
        );
      })
    );
  }
}


