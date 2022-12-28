import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'otpPage.dart';

class OtpHome extends StatefulWidget {
  const OtpHome({super.key});

  @override
  _OtpHomeState createState() => _OtpHomeState();
}

class _OtpHomeState extends State<OtpHome> {
  final TextEditingController _controller = TextEditingController();

  bool _areFieldsFilled() {
    if (_controller.text.isEmpty) {
      _showToast("Please provide your number");
      return false;
    }
    return true;
  }

  _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: const Text('Share',
                      style: TextStyle(
                          fontSize: 70.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                  child: const Text('MyRide',
                      style: TextStyle(
                          fontSize: 70.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(255.0, 165.0, 0.0, 0.0),
                  child: const Text('.',
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 100.0, 0.0, 0.0),
              child: const Text(
                "You'll receive a\n4 digit code to verify next",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  prefix: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('+92'),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 60.0,
              child: ElevatedButton(
                onPressed: () {
                  if (_areFieldsFilled()) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OtpPage(
                              phone: _controller.text,
                            )));
                  }
                },
                child: const Text(
                  'NEXT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 170),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "©2022, IU Ride",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
