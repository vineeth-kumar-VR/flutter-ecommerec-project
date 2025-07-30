import 'package:demologin/loginlogout.dart/login.dart';
import 'package:demologin/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  final String searchtext;
  final String searchcolor;
  final String searchprice;
  final String searchunit;
  final String searchsize;
  const OnboardingPage({super.key,required this.searchtext,required this.searchcolor,required this.searchprice,required this.searchunit,required this.searchsize});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  bool isactivate = false;
 final List<Map<String,dynamic>> content = [

   {
     "image":"assets/image/qualityproduct.jpg",
     "title":"Quality Product",
     "description":"Discover premium quality products that meet the highest standards. Shop with confidence, knowing every item is crafted to perfection for you!",
   },
   {
     "image":"assets/image/fastdelivery.jpg",
     "title":"Fast Delivery",
     "description":"Experience lightning-fast delivery with every order. Get your favorite products delivered to your doorstep in record time, every time!",
   },
   {
     "image":"assets/image/reward.jpg",
     "title":"Earn Rewards",
     "description":"Earn exciting rewards with every purchase! Collect points and enjoy exclusive discounts, deals, and more on your next shopping spree!",
   }
 ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

PageView.builder(
    controller: _controller,
    itemCount: content.length,
    onPageChanged: (index){
  setState(() {
    isactivate = index == content.length-1;
  });
    },
    itemBuilder: (context,index){
  var cont = content[index];
  return OnBoard(image: cont["image"]!, description: cont["description"]!, title: cont["title"]!);
}),


          Positioned(
            bottom: 100,
            left: 150,
            child: SmoothPageIndicator(controller: _controller, count: content.length,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.teal,
            dotHeight: 10,
            dotWidth: 10
          ),
          ),

          ),
          Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SizedBox(
            width: double.infinity,
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal
                      ),
                    onPressed: () async {
                      if (isactivate) {
                        SharedPreferences prefer = await SharedPreferences.getInstance();
                        await prefer.setBool("onboard_done", true);

                        // 🔥 Go to LoginPage instead of HomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      } else {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                      }
                    },



                    child: Text(isactivate?"Get Start":"Next",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
          ))
        ],
      ),
    );
  }
}
class OnBoard extends StatefulWidget {
  String image;
  String title;
  String description;
   OnBoard({super.key,required this.image,required this.description,required this.title});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(padding: EdgeInsets.all(10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(widget.image,height: 200,width: 300,fit: BoxFit.cover,)),
          SizedBox(height: 10,),
          Text(widget.title,style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text(widget.description,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey),)
        ],
      ),
      ),
    );
  }
}
