import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:movie_app/Screens/DashBoard/DashBoardScreen.dart';
import 'package:movie_app/constants.dart';
import 'package:flutter/material.dart';

import 'Screens/DashBoard/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        backgroundColor: kPrimaryColor,
        animationDuration: Duration(microseconds: 150000),
        splashIconSize: 300,
        splash: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            new Expanded(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(100, 50, 100, 0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset("assets/primeLogo.png",
                        fit: BoxFit.fitHeight),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Movies Anywhere",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22),
                      ),SizedBox(
                        height: 5,
                      ),
                      Text(
                        "YOUR MOVIES,TOGETHER AT LAST",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        screenFunction: () async {
          return DashBoardScreen();
        },
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
