import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

String encFilepath;
String decFilepath;
// انشاء object من داله التشفير مع المفتاح
var crypt = AesCrypt('flutteroqbahdx');

class EncryptionPage extends StatefulWidget {
  @override
  _EncryptionPageState createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage> {
  bool _isGranted = true;
  // اعطاء التطبيق امكانيه انشاء مجلد
  Future<Directory> get getAppDir async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir;
  }

  Future<Directory> get getExternalVisibleDir async {
    // هنا التأكد من ان المجلد الخاص بتشفير البيانات موجود او لا اذا موجود يتم تجاهله
    if (await Directory('/storage/emulated/0/MyEncFolder/Encrypt').exists()) {
      final externalDir = Directory('/storage/emulated/0/MyEncFolder/Encrypt');
      return externalDir;
    } else {
      // هنا اذا كان غير موجود يتم انشاء المجلد الخاص بتشفير البيانات
      await Directory('/storage/emulated/0/MyEncFolder/Encrypt')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/MyEncFolder/Encrypt');
      return externalDir;
    }
  }

  Future<Directory> get getExternalVisibleDir2 async {
    // هنا التأكد من ان المجلد الخاص بفك تشفير البيانات موجود او لا اذا موجود يتم تجاهله

    if (await Directory('/storage/emulated/0/MyEncFolder/Decrypt').exists()) {
      final externalDir = Directory('/storage/emulated/0/MyEncFolder/Decrypt');
      return externalDir;
    } else {

      // هنا اذا كان غير موجود يتم انشاء المجلد الخاص بفك تشفير البيانات

      await Directory('/storage/emulated/0/MyEncFolder/Decrypt')
          .create(recursive: true);
      final externalDir = Directory('/storage/emulated/0/MyEncFolder/Decrypt');
      return externalDir;
    }
  }

   // طلب صلاحيات الوصول لذاكره الجهاز حتي يتم الوصول للبيانات المراد تشفيرها
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
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    getStoragePermission();
    return Scaffold(
        appBar: AppBar(
          title: Text('تشفير الملفات',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0XFF000D92),
                    Color(0XFF000106),
                  ],
                )),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (_isGranted) {
                    Directory d = await getExternalVisibleDir;
                    FilePickerResult result =
                    await FilePicker.platform.pickFiles();
                    File file = File(result.files.single.path);
                    // الاكواد الخاصه بالتشفير
                    try {
                      //  crypt.setOverwriteMode(AesCryptOwMode.on);
                      final File newFile = await file
                          .copy('${d.path}/${file.path.split('/').last}');
                      encFilepath = crypt.encryptFileSync(newFile.path);
                      await newFile.delete();
                      print('The encryption has been completed successfully.');
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.black,
                            content: Text("تم تشفير الملف بنجاح",style: TextStyle(fontWeight: FontWeight.bold),),));
                      print('Encrypted file: $encFilepath');
                    } on AesCryptException catch (e) {
                      if (e.type == AesCryptExceptionType.destFileExists) {
                        print(
                            'The encryption has been completed unsuccessfully.');
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.black,
                              content: Text("هذا الملف مشفر بالفعل",style: TextStyle(fontWeight: FontWeight.bold),),));
                        print("message : ${e.message}");
                      }
                      return;
                    }
                  } else {
                    print('no permission granted');
                    getStoragePermission();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: _height * 0.065,
                  width: _width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0XFF000D92),
                          Color(0XFF000106),
                        ]),
                  ),
                  child: Text(
                    'اختار ملف للتشفير',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: _height * 0.1,
              ),
              GestureDetector(
                onTap: ()async{
                  if (_isGranted) {
                    // الاكواد الخاصه بفك التشفير
                    Directory d = await getExternalVisibleDir2;
                    FilePickerResult result =
                    await FilePicker.platform.pickFiles();
                    File file = File(result.files.single.path);
                    final File newFile = await file
                        .copy('${d.path}/${file.path.split('/').last}');
                    try {
                      crypt.setPassword('flutteroqbahdx');
                      decFilepath = crypt.decryptFileSync(newFile.path);
                      await newFile.delete();
                      print(
                          'The decryption has been completed successfully.');
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.black,
                            content: Text("تم فك تشفير الملف بنجاح",style: TextStyle(fontWeight: FontWeight.bold),),));
                      print('Decrypted file 1: $decFilepath');
                      print('File content: ' +
                          File(decFilepath).readAsStringSync() +
                          '\n');
                    } on AesCryptException catch (e) {
                      if (e.type == AesCryptExceptionType.destFileExists) {
                        print(
                            'The decryption has been completed unsuccessfully.');
                        print(e.message);
                      }
                    }
                    // _decryptFile(newFile);
                  } else {
                    print('no permission granted');
                    getStoragePermission();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: _height * 0.065,
                  width: _width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0XFF000D92),
                          Color(0XFF000106),
                        ]),
                  ),
                  child: Text(
                    'اختار ملف لفك التشفير',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
