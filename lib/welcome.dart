import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

File _file;

class Welcome extends StatefulWidget {
  static String id = "Welcome";

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _isGranted = true;

  Future<Directory> get getAppDir async {
    final appDocDir = await getApplicationDocumentsDirectory();
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
                FilePickerResult result = await FilePicker.platform.pickFiles();
                _file = File(result.files.single.path);
                _downloadAndCreate(d, _file.path.split('/').last, _file.path);
              } else {
                print('no permission granted');
                getStoragePermission();
              }
            },
            child: Text(
              'اختار ملف للتشفير ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_isGranted) {
                Directory d = await getExternalVisibleDir;
                FilePickerResult result = await FilePicker.platform.pickFiles();
                _file = File(result.files.single.path);
                _getNormalFile(d, _file);
              } else {
                print('no permission granted');
                getStoragePermission();
              }
            },
            child: Text(
              'فك تشفير الملف',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    ));
  }
}

void _downloadAndCreate(Directory dir, fileName, filePath) async {
  print('data downloading ...');
  Fluttertoast.showToast(msg: 'data downloading ...');
  var encResult = _encryptData(_file.path.codeUnits);
  String p = await _writeData(encResult, dir.path + '/$fileName.aes');
  print('file encrypted Successfully $p');
  Fluttertoast.showToast(msg: 'تم تشفير الملف بنجاح$p');
}

_getNormalFile(Directory d, File fileNameNew) async {
  Uint8List encData = await _readData(fileNameNew.readAsBytesSync());
  var plainData = await _decryptData(encData);
  String p = await _writeData(plainData, fileNameNew.path);
  print('file decrypted Successfully $p');
  Fluttertoast.showToast(msg: 'تم فك تشفير الملف بنجاح $p');
}

Future<Uint8List> _readData(fileNameWithPath) async {
  print('Reading data ...');
  Fluttertoast.showToast(msg: 'قراءه البيانات ...');
  return await fileNameWithPath;
}

_decryptData(encData) {
  print('جاري فك التشفير ...');
  Fluttertoast.showToast(msg: 'File decryption is progress...');
  encrypt.Encrypted enc = new encrypt.Encrypted(encData);
  return MyEncrypt.myEncrypter.decryptBytes(enc, iv: MyEncrypt.myIv);
}

_encryptData(List<int> plainString) {
  print('Encrypting File...');
  Fluttertoast.showToast(msg: 'جاري تشفير الملف ...');
  final encrypted =
      MyEncrypt.myEncrypter.encryptBytes(plainString, iv: MyEncrypt.myIv);
  print("test : ${encrypted.bytes}");
  return encrypted.bytes;
}

Future<String> _writeData(dataToWrite, fileNameWithPath) async {
  print('كتابه البيانات ...');
  Fluttertoast.showToast(msg: 'كتابه البيانات ...');
  _file = File(fileNameWithPath);

  await _file.writeAsBytes(dataToWrite);

  return _file.absolute.toString();
}

class MyEncrypt {
  static final myKey = encrypt.Key.fromUtf8('Oqbahahmeddxflutterapplication29');
  static final myIv = encrypt.IV.fromUtf8('hfyrujfisoldkide');
  static final myEncrypter =
      encrypt.Encrypter(encrypt.AES(myKey, padding: null));
}
