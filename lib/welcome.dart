import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Welcome extends StatefulWidget {
  static String id = "Welcome";

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _isGranted = true;
 File _file;
  String _fileName = "demo.jpeg";
  String imageUrl = "https://i.imgur.com/1kP2Hlz.jpeg";
  var myDir = new Directory('myDir');
  Future<Directory> get getAppDir async {
    final appDocDir = await getExternalStorageDirectory();
    return appDocDir;
  }

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory('/storage/emulated/0/MyEncFolder').exists()) {
      final externalDir = Directory('/storage/emulated/0/MyEncFolder');
      return externalDir;
    } else {
      await Directory('/storage/emulated/0/MyEncFolder')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/MyEncFolder');
      return externalDir;
    }
  }

  getStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      if (result.isGranted) {
        setState(() {
          _isGranted = true;
        });
      } else {
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
          ElevatedButton(
            onPressed: () async {
              if (_isGranted) {
                Directory d = await getExternalVisibleDir;
              //  FilePickerResult result = await FilePicker.platform.pickFiles();
              //  _file = File(result.files.single.path);
                  void _downloadAndCreate(String url, Directory dir, fileName) async {
                    if (await canLaunch(url)) {
                      print('data downloading ...');
                      Fluttertoast.showToast(msg: 'data downloading ...');
                      var res = await http.get(Uri.parse(url));
                      var encResult = _encryptData(res.bodyBytes);
                      String p = await _writeData(encResult, dir.path + '/$fileName.aes ');
                      print('file encrypted Successfully $p');
                      Fluttertoast.showToast(msg: 'file encrypted Successfully $p');
                    }else{
                      print('can not launch url');
                    }
                  }
                  _downloadAndCreate(imageUrl, d,_fileName);

              } else {
                print('no permission granted');
                getStoragePermission();
              }
            },
            child: Text('download and encrypt'),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_isGranted) {
                Directory d = await getExternalVisibleDir;
               // FilePickerResult result = await FilePicker.platform.pickFiles();
              //  _file = File(result.files.single.path);
              //  print(" file path :${_file.path}");
                  _getNormalFile(d,_fileName);
              } else {
                print('no permission granted');
                getStoragePermission();
              }
            },
            child: Text('Decrypted'),
          ),
        ],
      ),
    ));
  }
}

void _getNormalFile(Directory dir, fileName) async {
  Uint8List encData = await _readData(dir.path + '/$fileName.aes ');
  print("*****");
  var plainData = await _decryptData(encData);
  print("*****");
  String p = await _writeData(plainData, dir.path + '/$fileName');
  print('file decrypted Successfully $p');
  Fluttertoast.showToast(msg: 'file decrypted Successfully $p');
}




_encryptData(plainString) {
  print('Encrypting File...');
  Fluttertoast.showToast(msg: 'Encrypting File...');
  final encrypted =
      MyEncrypt.myEncrypter.encryptBytes(plainString, iv: MyEncrypt.myIv);
  print("test : ${encrypted.bytes}");
  return encrypted.bytes;
}

_decryptData(encData) {
  print('File decryption is progress...');
  Fluttertoast.showToast(msg: 'File decryption is progress...');
  encrypt.Encrypted enc = new encrypt.Encrypted(encData);
  return MyEncrypt.myEncrypter.decryptBytes(enc, iv: MyEncrypt.myIv);
}


Future<Uint8List> _readData(fileNameWithPath) async {
  print('Reading data ...');
  Fluttertoast.showToast(msg: 'Reading data ...');
  File f = File(fileNameWithPath);
  print(" f : path : ${f.path}");
  return await f.readAsBytesSync();
}

Future<String> _writeData(dataToWrite, fileNameWithPath) async {
  print('writing data ...');
  Fluttertoast.showToast(msg: 'writing data ...');
  File f = File(fileNameWithPath);

  await f.writeAsBytes(dataToWrite);

  return f.absolute.toString();
}

class MyEncrypt {
  static final myKey = encrypt.Key.fromUtf8('Oqbahahmeddxflutterapplication29');
  static final myIv = encrypt.IV.fromUtf8('hfyrujfisoldkide');
  static final myEncrypter = encrypt.Encrypter(encrypt.AES(myKey));
}
