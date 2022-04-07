//import 'package:flutter_application_2/design_course/home_design_course.dart';
import 'package:cricketapp/dash_screen.dart';
//import 'package:flutter_application_2/hotel_booking/hotel_home_screen.dart';
//import 'package:flutter_application_2/animation/introduction_animation_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/home_app/fitness_app.png',
      navigateScreen:  const DashScreen(),
    ),
    
  ];
}
