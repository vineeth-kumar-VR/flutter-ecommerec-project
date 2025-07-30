import 'dart:async';
import 'package:demologin/pages/home.dart';
import 'package:demologin/pages/onboardingpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;
  void initState(){
    super.initState();
    Timer(Duration(milliseconds: 300),(){
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });

    Timer(
      Duration(seconds: 3),(){
        onboardingstatus();
    }
    );
  }

  void onboardingstatus() async{
    SharedPreferences prefer = await SharedPreferences.getInstance();
    bool onboarddone =  prefer.getBool("onboard_done") ?? false;
    
    if(onboarddone){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(searchtext: "", searchcolor: "", searchprice: "", searchunit: "", searchsize: "")));
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>OnboardingPage(searchtext: "",searchcolor: "",searchprice: "",searchunit: "",searchsize: "",)));

    }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(opacity: _opacity, duration: Duration(seconds: 1),
        child: AnimatedScale(scale: _scale, duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12), // Adjust for roundness
            child: Image.asset(
              "assets/image/ecommerecicon.jpg",
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
        ),
      ),
    );
  }
}
