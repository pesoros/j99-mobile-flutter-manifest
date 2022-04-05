// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:j99_mobile_manifest_flutter/screens/login_screen.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'assets/images/j99-logo.png',
      ),
      logoSize: MediaQuery.of(context).size.width / 3,
      backgroundColor: Colors.black,
      loaderColor: Colors.red,
      showLoader: true,
      loadingText: Text("Loading..."),
      navigator: LoginScreen(),
      durationInSeconds: 3,
    );
  }
}
