// ignore_for_file: unnecessary_const, unnecessary_new

import 'package:cricketapp/main.dart';
import 'package:flutter/material.dart';
import '../hometheme.dart';

class WorkoutView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const WorkoutView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    HomeAppTheme.nearlyDarkBlue,
                    HexColor("#6F56E8")
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: const Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: HomeAppTheme.grey.withOpacity(0.6),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Cricket Matches',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: HomeAppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: HomeAppTheme.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Quite honestly, cricket is same at all levels \n It is a game of bat and ball',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: HomeAppTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            letterSpacing: 0.0,
                            color: HomeAppTheme.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            
                            Container(
                              decoration: BoxDecoration(
                                color: HomeAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: HomeAppTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: const Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              // ignore: sized_box_for_whitespace
                              child: Container(
                              height: 80,
                              width: 80,
                              //color: Colors.transparent,
                                child: Image.asset('assets/home_app/logo5.png'),
                                  
                                  //color: HexColor("#6F56E8"),
                                  //size: 50,
                                ),
                              ),
                              Container(
                              decoration: BoxDecoration(
                                color: HomeAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: HomeAppTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: const Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Container(
                              height: 80,
                              width: 80,
                              color: Colors.transparent,
                                child: Image.asset('assets/home_app/logo3.png'),
                                  
                                  //color: HexColor("#6F56E8"),
                                  //size: 50,
                                ),
                              ),
                            Container(
                              decoration: BoxDecoration(
                                color: HomeAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: HomeAppTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: const Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Container(
                              height: 80,
                              width: 80,
                              color: Colors.transparent,
                                child: Image.asset('assets/home_app/logo6.png'),
                                  
                                  //color: HexColor("#6F56E8"),
                                  //size: 50,
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
