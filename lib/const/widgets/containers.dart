import 'package:encryptionfiles/const/colors.dart';
import 'package:flutter/material.dart';

Widget defaultContainer({double h ,String txt, Function onTap}){
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        alignment: Alignment.center,
        height: h,
        width:double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradientColors),
        ),
        child: Text(
          txt,
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
