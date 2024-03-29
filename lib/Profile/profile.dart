import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../sharedPreferences/sharedPreferences.dart';
import 'dart:developer';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProfilePage> {
  // final _firestore = FirebaseFirestore.instance;
  String name = "";
  String year = "";
  String branch = "";
  String phone = "";
  String email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  fetchData() async {
    MySharedPreferences.instance
        .getStringValue("userName")
        .then((value) => setState(() {
              name = value;
            }));
    MySharedPreferences.instance
        .getStringValue("userBranch")
        .then((value) => setState(() {
              branch = value;
            }));
    MySharedPreferences.instance
        .getStringValue("userYear")
        .then((value) => setState(() {
              year = value;
            }));
    MySharedPreferences.instance
        .getStringValue("userPhone")
        .then((value) => setState(() {
              phone = value;
            }))
        .then((value) => {log('Phone :$phone')});
    MySharedPreferences.instance
        .getStringValue("email")
        .then((value) => setState(() {
              email = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 20),
        child: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "My Profile",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: GetClipper(),
            child: Container(color: Colors.black.withOpacity(1)),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height / 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: "profile",
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: AssetImage('assets/accountAvatar.png'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(105.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 9.0, color: Colors.black)
                        ]),
                  ),
                ),
                const SizedBox(height: 40.0),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 25.0,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      getBranch(branch),
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        // fontStyle: FontStyle.it,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      " - " + getYear(year),
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                      text: "Phone: ",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: phone,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        )
                      ]),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                      text: "Email: ",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: email,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Image(
                  image: AssetImage("assets/signUp.jpg"),
                  width: 290,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      _signOut();
                      Navigator.pushNamed(context, '/otpHome');
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.clear();
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 3.5);
    path.lineTo(size.width + 60500, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

getBranch(String branch) {
  if (branch == 'CSE') return 'Computer Science';
  if (branch == 'ECE') return 'Electronics & Communication';
  if (branch == 'IT') return 'Information Technology';
  if (branch == 'EEE') return 'Electronics & Electrical';
  if (branch == 'MECH') return 'Mechanical Engineering';
  if (branch == 'AUTO') return 'Automobile Engineering';
  if (branch == 'EIE') return 'Electronics & Instrumentation';
  return branch;
}

getYear(String year) {
  if (year == "1") return '1st Year';
  if (year == "2") return '2nd Year';
  if (year == "3") return '3rd Year';
  if (year == "4") return '4th Year';
  return year;
}
