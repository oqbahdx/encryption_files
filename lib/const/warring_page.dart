import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class WarringPage extends StatelessWidget {
  const WarringPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3),(){
      openAppSettings();
    });
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Please Enable Security Setting',style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold
          ),textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
