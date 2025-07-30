import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  void _launchGoogle() async {
    final Uri url = Uri.parse('https://www.google.com');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("data")),
      body: Center(
        child: IconButton(
          onPressed: _launchGoogle,
          icon: Icon(Icons.menu),
        ),
      ),
    );
  }
}
