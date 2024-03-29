//import 'dart:ui';
import 'dart:async';
import 'package:cricketapp/pages/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cricketapp/pages/home.dart';
import 'package:cricketapp/homescreen/dash_screen.dart';
import 'package:splashscreen/splashscreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CricketApp());
}

class CricketApp extends StatelessWidget {
  const CricketApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cric Info',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff0000FF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash1(),

    );
  }
}

class Splash1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: const Authentication(),
      title: new Text(
        'Cric Info',
        textAlign: TextAlign.center,
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.yellowAccent),
      ),
      image: new Image.asset('assets/cricket_logo01.png'),
      photoSize: 100.0,
      backgroundColor: Color(0xff0000FF),
      styleTextUnderTheLoader: new TextStyle(),
      loaderColor: Colors.white,
    );
  }
}
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}