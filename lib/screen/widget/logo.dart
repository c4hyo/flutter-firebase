import 'package:flutter/material.dart';

Widget logoLogin(BuildContext context) {
  return Stack(
    children: [
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            maxRadius: 50,
          ),
        ),
      ),
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: CircleAvatar(
            backgroundColor: Color(0xFFF5C35C),
            maxRadius: 45,
          ),
        ),
      ),
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: CircleAvatar(
            backgroundColor: Colors.amber[50],
            maxRadius: 40,
            child: Image(
              image: AssetImage("assets/logo.png"),
              height: 40,
            ),
          ),
        ),
      ),
    ],
  );
}
