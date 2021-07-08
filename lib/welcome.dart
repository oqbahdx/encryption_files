import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encryptionfiles/my_encryption_files.dart';
import 'package:file_picker/file_picker.dart';
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
  File _file;
  String _fileName;
  Future<Directory> get getAppDir async {
    final appDocDir = await getExternalStorageDirectory();
    return appDocDir;
  }

  Future<Directory> get getExternalVisibleDir async{
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
    getStoragePermission();
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed:()async{
               if(_isGranted){
                 Directory d = await getExternalVisibleDir;
                 _downloadAndCreate(_file,d,_fileName);
               }else{
                 print('no permission granted');
                 getStoragePermission();
               }
            },
           child: Text('download and encrypt'),
           ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed:()async{
              if(_isGranted){
                Directory d = await getExternalVisibleDir;
                _getNormalFile(d,_fileName);
              }else{
                print('no permission granted');
                getStoragePermission();
              }
            },
              child: Text('Decrypted'),
            ),



          ],
        ),
      )
    );
  }
}

void _downloadAndCreate(File file , Directory dir , String fileName)async {
  FilePickerResult result = await FilePicker.platform.pickFiles();

  if(result != null) {
    File file = File(result.files.single.path);
    var res = file;
    var encResult = _encryptData(res.readAsBytes());
    String p = await _writeData(encResult , dir.path + '/$fileName.aes');
    print('file encrypted Successfully : $p');
  } else {
    print('can\'t encrypt file ');
  }

}

void _getNormalFile(Directory dir, String fileName) async{

   Uint8List encData = await _readData(dir.path + '/$fileName.aes');
   var plainData = await _decryptData(encData);
   String p = await _writeData(plainData , dir.path + '/$fileName.aes');
   print('file decrypted Successfully $p');


}
_encryptData(plainString){
  print('Encrypting File...');
  final encrypted = MyEncrypt.MyEncrypter.encryptBytes(plainString,iv: MyEncrypt.myIv);
  return encrypted.bytes;
}
_decryptData(encData){
  print('File decryption is progress...');
  encrypt.Encrypted enc = new encrypt.Encrypted(encData);
  return MyEncrypt.MyEncrypter.decryptBytes(enc,iv: MyEncrypt.myIv);
}

Future<Uint8List> _readData(fileNameWithPath)async{
  print('Reading data ...');
  File f = File(fileNameWithPath);
  return await f.readAsBytes();
}

Future<String> _writeData(dataToWrite,fileNameWithPath)async{
  print('writting data ...');
  File f = File(fileNameWithPath);
  await f.writeAsBytes(dataToWrite);
  return f.absolute.toString();
}

class MyEncrypt{
  static final myKey = encrypt.Key.fromUtf8('Oqbahahmeddxflutterapplication29');
  static final myIv = encrypt.IV.fromUtf8('hfyrujfisoldkide');
  static final MyEncrypter = encrypt.Encrypter(encrypt.AES(myKey));
}


