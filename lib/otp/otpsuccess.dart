import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OtpSuccess extends StatefulWidget {
  const OtpSuccess({super.key});

  @override
  State<OtpSuccess> createState() => _OtpSuccessState();
}

class _OtpSuccessState extends State<OtpSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 200),
              Center(
                child: Container(
                  child: Lottie.asset("assets/image/otp_success.json"),
                ),
              ),
              Text(
                "Succesfully",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 150),
              Container(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Okey", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
