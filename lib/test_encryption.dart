import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

String encFilepath;
String decFilepath;
var crypt = AesCrypt('flutteroqbahdx');

class TestEncryption extends StatefulWidget {
  @override
  _TestEncryptionState createState() => _TestEncryptionState();
}

class _TestEncryptionState extends State<TestEncryption> {
  bool _isGranted = true;

  Future<Directory> get getAppDir async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir;
  }

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory('/storage/emulated/0/MyEncFolder/Encrypt').exists()) {
      final externalDir = Directory('/storage/emulated/0/MyEncFolder/Encrypt');
      return externalDir;
    } else {
      await Directory('/storage/emulated/0/MyEncFolder/Encrypt')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/MyEncFolder/Encrypt');
      return externalDir;
    }
  }

  Future<Directory> get getExternalVisibleDir2 async {
    if (await Directory('/storage/emulated/0/MyEncFolder/Decrypt').exists()) {
      final externalDir = Directory('/storage/emulated/0/MyEncFolder/Decrypt');
      return externalDir;
    } else {
      await Directory('/storage/emulated/0/MyEncFolder/Decrypt')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/MyEncFolder/Decrypt');
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
                File file = File(result.files.single.path);
                try {
                //  crypt.setOverwriteMode(AesCryptOwMode.on);

                    final File newFile =
                    await file.copy('${d.path}/${file.path.split('/').last}');
                    encFilepath = crypt.encryptFileSync(newFile.path);

                  print('The encryption has been completed successfully.');
                  print('Encrypted file: $encFilepath');
                } on AesCryptException catch (e) {
                  if (e.type == AesCryptExceptionType.destFileExists) {
                    print('The encryption has been completed unsuccessfully.');
                    print("message : ${e.message}");
                  }
                  return;
                }
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
                Directory d = await getExternalVisibleDir2;
                FilePickerResult result = await FilePicker.platform.pickFiles();
                File file = File(result.files.single.path);
                final File newFile =
                    await file.copy('${d.path}/${file.path.split('/').last}');
                _decryptFile(newFile);
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

_decryptFile(File file) {
  try {
    crypt.setPassword('flutteroqbahdx');
    decFilepath = crypt.decryptFileSync(file.path);
    print('The decryption has been completed successfully.');
    print('Decrypted file 1: $decFilepath');
    print('File content: ' + File(decFilepath).readAsStringSync() + '\n');
  } on AesCryptException catch (e) {
    if (e.type == AesCryptExceptionType.destFileExists) {
      print('The decryption has been completed unsuccessfully.');
      print(e.message);
    }
  }
}
