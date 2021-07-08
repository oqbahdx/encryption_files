import 'dart:io';

import 'package:encryptionfiles/my_encryption_files.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Welcome extends StatefulWidget {

  static String id = "Welcome";

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _isGranted;
  File fileName;
  Future<Directory> get getAppDir async {
    final appDocDir = await getExternalStorageDirectory();
    return appDocDir;
  }

  Future<Directory> get getExternalDirectory async{
    if(await Directory('/storage/emulated/0/MyEncFolder').exists()){
      final externalDir = Directory('/storage/emulated/0/MyEncFolder');
      return externalDir;
    }else{
      await Directory('/storage/emulated/0/MyEncFolder').create(
        recursive: true);
      final externalDir = Directory('/storage/emulated/0/MyEncFolder');
      return externalDir;
    }
  }

  getStoragePermission()async{
    if(!await Permission.storage.isGranted){
      PermissionStatus result = await Permission.storage.request();
      if(result.isGranted){
        setState(() {
          _isGranted = true;
        });
      }else{
        setState(() {
          _isGranted = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed:(){

            },
           child: Text('Encrypted'),
           ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed:(){

            },
              child: Text('Decrypted'),
            ),



          ],
        ),
      )
    );
  }
}
