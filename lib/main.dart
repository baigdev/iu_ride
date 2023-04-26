import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen/findaRide.dart';
import 'HomeScreen/homeScreen.dart';
import 'Profile/profile.dart';
import 'auth/otpHome.dart';
import 'auth/otpPage.dart';
import 'auth/registerUser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  runApp(MyApp(screen: isLoggedIn ? HomeScreen() : const OtpHome()));
}

class MyApp extends StatelessWidget {
  final Widget? screen;
  const MyApp({super.key, this.screen});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IU Ride',
      //test phase
      home: screen,
      routes: {
        '/outcome': (context) => const OtpHome(),
        '/otppage': (context) => OtpPage(),
        '/otpHome': (context) => const OtpHome(),
        '/homescreen': (context) => HomeScreen(),
        '/register': (context) => SignUp(),
        '/profile': (context) => const ProfilePage(),
        '/finder': (context) => FindaRide(),
      },
    );
  }
}
