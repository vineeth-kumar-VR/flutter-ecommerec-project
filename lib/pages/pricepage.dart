import 'package:demologin/database/firestore.dart';
import 'package:flutter/material.dart';

class PricePage extends StatefulWidget {
  final Function(String) iseselectprice;
  final double? selectprice;
  final String searchprice;
 const PricePage({super.key,required this.iseselectprice,required this.selectprice,required this.searchprice});

  @override
  State<PricePage> createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  List<double> prices = [];
double? _selectprice;

  @override
  void initState(){
    super.initState();
    _selectprice = widget.selectprice;
    fetchprice();
  }

  Future<void> fetchprice()async{
    final data =await Firestore().fetchpriceonly(widget.searchprice.toString());
    print("Fetched prices: $data");
    setState(() {
      prices = data.map((e)=>double.parse(e.toString())).toList();
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body:prices.isEmpty?Center(child: CircularProgressIndicator(color: Colors.white,),):Column(
        children: [
          Expanded(
            child: ListView.builder(itemCount: prices.length, itemBuilder: (context,index){
              var pricess = prices[index];
              print(pricess);

              return Padding(padding: EdgeInsets.all(12),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Price:\$${pricess.toStringAsFixed(2)}",style: TextStyle(color: Colors.white,fontSize: 18)),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectprice = pricess;
                        widget.iseselectprice(pricess.toString());
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2,color: Colors.white),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(child:_selectprice == pricess?Icon(Icons.check,color: Colors.white,):null,),
                    ),
                  ),

                ],
              ),
              );
            }),
          ),

        ],
      )
    );
  }
}
