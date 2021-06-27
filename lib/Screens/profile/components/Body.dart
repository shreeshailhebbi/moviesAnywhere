import 'package:flutter/material.dart';
import 'package:movie_app/Screens/profile/components/ProfileMenu.dart';
import 'package:movie_app/Screens/profile/components/ProfilePic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_app/constants.dart';

class Body extends StatelessWidget {

  getToastBar(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {getToastBar("My Account Coming Soon..!")},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {getToastBar("Notifications Coming Soon..!");},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {getToastBar("Settings Coming Soon..!");},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {getToastBar("Help Center will Available Soon..!");},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}