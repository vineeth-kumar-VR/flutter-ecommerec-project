import 'package:demologin/pages/brandpage.dart';
import 'package:demologin/pages/colorpage.dart';
import 'package:demologin/pages/pricepage.dart';
import 'package:demologin/pages/sizepage.dart';
import 'package:demologin/pages/unitpage.dart';
import 'package:flutter/material.dart';

class FiltersPage extends StatefulWidget {
  String? selectedColor;
  double? selectPrice;
  String? selectBrand;
  String? selectUnit;
  String? selectSize;
  final String searchtext;
  final String searchcolor;
  final String searchprice;
  final String searchunit;
  final String searchsize;

  FiltersPage({super.key,required this.selectedColor,required this.selectPrice,required this.selectBrand,required this.selectUnit,required this.selectSize, required this.searchtext,required this.searchcolor,required this.searchprice,required this.searchunit,required this.searchsize});

  @override

  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  String? selectedcolor;
  double? selectedprice;
  String? selectedbrand;
  String? selectedunit;
  String? selectedsize;

  @override
  void initState(){
    super.initState();
    selectedcolor = widget.selectedColor;
    selectedprice = widget.selectPrice;
    selectedbrand = widget.selectBrand;
    selectedunit = widget.selectUnit;
    selectedsize = widget.selectSize;

  }
  Widget build(BuildContext context) {
    return DefaultTabController(length: 5, child: Scaffold(backgroundColor: Colors.teal,
      appBar: AppBar(backgroundColor: Colors.teal, centerTitle: true, title: Text("Filters",style: TextStyle(color: Colors.white),),
      ),

      body: Column(
        children: [
          TabBar(
              labelStyle: TextStyle(fontWeight: FontWeight.bold,

              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.2),
              indicatorColor: Colors.teal,
              tabs: [
                Tab(text: "COLORS",),
                Tab(text: "PRICE",),
                Tab(text: "BRAND",),
                Tab(text: "UNIT",),
                Tab(text: "SIZE",)

              ]),
          Expanded(child: TabBarView(children: [
ColorPage(oncolorselect: (color){
  setState(()=> selectedcolor = color
  );
},
        selectedcolor:selectedcolor,
  searchcolor: widget.searchcolor,
),
            PricePage(
              iseselectprice: (price) {
                setState(() {
                  selectedprice = double.tryParse(price);
                });
              },

              selectprice: selectedprice,
              searchprice:widget.searchprice
            ),

            BrandPage(isselectbrand: (brand){
              setState(() {
                selectedbrand = brand.trim();
              }
              );
            },
selectbrand: selectedbrand,
searchtext:widget.searchtext,

            ),
            UnitPage(isselectunit: (unit){
              setState(() {
                selectedunit = unit;
              }
              );
            },
                selectunit: selectedunit,
              searchunit: widget.searchunit,
            ),
            SizePage(
              onselectsize: (size){
                setState(() {
                  selectedsize = size;
                });
              },
              selectsize: selectedsize,
              searchsize: widget.searchsize,
            ),

          ])),
          Padding(
            padding: EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  print("Returning color: $selectedcolor");
                  print("Returning price: $selectedprice");
                  print("Returning brand: $selectedbrand");
                  print("Returning unit: $selectedunit");
                  final result = {
                    'color': selectedcolor,
                    'price': selectedprice,
                    'brand': selectedbrand,
                    'unit': selectedunit,
                  };
                  Navigator.pop(context,result);

                },
                child: Text("Apply", style: TextStyle(color: Colors.teal)),
              ),
            ),
          ),
        ],
      ),
    )


    );


  }
}
