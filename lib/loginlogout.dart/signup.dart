import 'package:demologin/database/firebase_auth.dart';
import 'package:demologin/database/firestore.dart';
import 'package:demologin/loginlogout.dart/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final Authentication _authentication = Authentication();
  final Firestore _firestore = Firestore();
  bool obscuretext = true;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  void _launchGoogle() async {
    final Uri url = Uri.parse('https://www.google.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
  void _launchFacebook() async {
    final Uri url = Uri.parse('https://www.facebook.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
  void _launchInstagram() async {
    final Uri url = Uri.parse('https://www.instagram.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }




  void display() async {
    String username = _username.text.trim();
    String email = _email.text.trim();
    String password = _password.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please Fill All The Fields")));
      return;
    }
    User? user = await _authentication.signup(email, password);
    if (user != null) {
      try {
        await _firestore.savedata(username, email, user.uid);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("SignUp Successful")));
        _email.clear();
        _password.clear();
        _username.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Signup error $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/image/logg.png"),
                  ),
                ),
                SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Please login or signup our app",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            width: 0.1,
                            color: Colors.grey,
                          ),
                        ),
                        labelText: "User Name",
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            width: 0.1,
                            color: Colors.grey,
                          ),
                        ),
                        labelText: "Phone or Email",
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _password,
                      obscureText: obscuretext,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            width: 0.1,
                            color: Colors.grey,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscuretext = !obscuretext;
                            });
                          },
                          icon: Icon(obscuretext ? Icons.visibility_rounded : Icons.visibility_off_outlined),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.teal,
                          ),
                        ),
                        onPressed: () => display(),
                        child: Center(
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Text(
                            "Already Have an Account?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                            },
                            child: Text(
                              "LogIn",
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: Text(
                        "-Or Signup with",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                         GestureDetector(
                           onTap: _launchGoogle,
                           child: Container(
                              height: 70,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  IconButton(
                                    onPressed: _launchGoogle,
                                    icon: Icon(
                                      Icons.favorite_sharp,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "Google",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                         ),

                        GestureDetector(
                          onTap: _launchFacebook,
                          child: Container(
                            height: 70,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              border: Border.all(width: 1.0, color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _launchFacebook();
                                  },
                                  icon: Icon(Icons.facebook, color: Colors.white),
                                ),
                                Text(
                                  "Facebook",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _launchInstagram,
                          child: Container(
                            height: 70,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _launchInstagram();
                                  },
                                  icon: Image.asset(
                                      height: 30,
                                      width: 40,
                                      "assets/image/instagram1.jpg")
                                ),

                                Text(
                                  "Instagram",
                                  style: TextStyle(color: Colors.pink),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
