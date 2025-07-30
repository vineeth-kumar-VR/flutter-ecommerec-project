import 'package:demologin/database/firestore.dart';
import 'package:flutter/material.dart';

class SizePage extends StatefulWidget {
  final Function(String) onselectsize;
  final String? selectsize;
  final String searchsize;
  const SizePage({super.key,required this.onselectsize,required this.selectsize,required this.searchsize});

  @override
  State<SizePage> createState() => _SizePageState();
}

class _SizePageState extends State<SizePage> {
   List<String> sizelist = [];
  String? _selectsize;
  @override
  void initState(){
    super.initState();
    _selectsize = widget.selectsize;
    fetchsize();
  }
  Future<void>fetchsize()async{
    List<String> size =await Firestore().fetchsizeonly(widget.searchsize);
    setState(() {
      sizelist = size;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: ListView.builder(itemCount: sizelist.length, itemBuilder: (context,index){
        var sizes = sizelist[index];
        return Padding(padding: EdgeInsets.all(12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Size:"+sizes,style: TextStyle(color: Colors.white,fontSize: 18)),
            GestureDetector(
              onTap: (){
                setState(() {
                  _selectsize = sizes;
                  widget.onselectsize(sizes);
                });
              },
              child: Container(
                child: Center(child:_selectsize == sizes?Icon(Icons.check,color:Colors.white):null,),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2,color: Colors.white)
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
