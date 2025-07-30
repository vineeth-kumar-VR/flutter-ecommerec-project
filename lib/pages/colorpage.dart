import 'package:demologin/database/firestore.dart';
import 'package:flutter/material.dart';
class ColorPage extends StatefulWidget {
  final Function(String) oncolorselect;
final String? selectedcolor;
final String searchcolor;
 const  ColorPage({super.key,required this.oncolorselect,required this.selectedcolor,required this.searchcolor});

  @override
  State<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  List<String> colors = [];

String? _selectedcolor;
  @override
  void initState(){
    super.initState();
    _selectedcolor = widget.selectedcolor;
    fetchcolor();
  }

  void fetchcolor()async{
    final fetch = await Firestore().fetchcoloronly(widget.searchcolor);
    setState(() {
      colors = fetch;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.teal,
      body:colors.isEmpty?Center(child: CircularProgressIndicator(color: Colors.green,),
      ):ListView.builder(itemCount: colors.length, itemBuilder: (context,index){
        var color = colors[index];
        print(color);
        return Padding(padding: EdgeInsets.all(12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(color,style: TextStyle(color: Colors.white,fontSize: 18),),
              GestureDetector(
                onTap: (){
                  setState(() {
                    _selectedcolor = color;
widget.oncolorselect(color);
                  });
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: Center(child:_selectedcolor == color?Icon(Icons.check,color: Colors.white, size: 18):null,),
                ),
              )
          ],
        ),
        );
      })
    );
  }
}
