import 'package:demologin/firebase_options.dart';
import 'package:demologin/loginlogout.dart/login.dart';
import 'package:demologin/loginlogout.dart/signup.dart';
import 'package:demologin/pages/activate.dart';
import 'package:demologin/pages/address.dart';
import 'package:demologin/pages/addresseditpage.dart';
import 'package:demologin/pages/addressedittabs.dart';
import 'package:demologin/pages/cart.dart';
import 'package:demologin/pages/checkout.dart';
import 'package:demologin/pages/filter.dart';
import 'package:demologin/pages/filters.dart';
import 'package:demologin/pages/home.dart';
import 'package:demologin/pages/onboardingpage.dart';
import 'package:demologin/pages/sample.dart';
import 'package:demologin/pages/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: SplashScreen()),
    );
  }
}
