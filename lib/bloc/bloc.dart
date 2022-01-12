import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:encryptionfiles/bloc/states.dart';
import 'package:encryptionfiles/const/widgets/messages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  String encFilepath;
  String decFilepath;

  var crypt = AesCrypt('flutteroqbahdx');
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

          _isGranted = true;
        emit(AppChangeGrantedValueState());
      } else {

          _isGranted = false;
          emit(AppChangeGrantedValueState());
      }
    }
  }
  void encryptionFile()async{

      if (_isGranted) {
         emit(AppEncryptionFileLoadingState());
        Directory d = await getExternalVisibleDir;
        FilePickerResult result =
            await FilePicker.platform.pickFiles();
        File file = File(result.files.single.path);
        emit(AppEncryptionFileLoadingState());
        try {

          //  crypt.setOverwriteMode(AesCryptOwMode.on);
          final File newFile = await file
              .copy('${d.path}/${file.path.split('/').last}');
          encFilepath = crypt.encryptFileSync(newFile.path);
          await newFile.delete();
          print('encryption has been successfully');
          showMessage(msg: 'File has been encrypted successfully',color: Colors.teal);
          print('Encrypted file: $encFilepath');
           emit(AppEncryptionFileSuccessState());
        } on AesCryptException catch (e) {
          if (e.type == AesCryptExceptionType.destFileExists) {
            print(
                'encryption does not complete');
            showMessage(msg: 'this file is already encrypted');
            print("message : ${e.message}");
            emit(AppEncryptionFileErrorState(e.toString()));
          }
          return;
        }
      } else {
        print('permission not granted');
        getStoragePermission();
      }

  }
  decryptionFile()async{

      if (_isGranted) {

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
          emit(AppDecryptionFileLoadingState());
          print(
              'The decryption has been completed successfully.');
            showMessage(msg: 'The decryption has been completed successfully',color: Colors.teal);
          print('Decrypted file 1: $decFilepath');
          print('File content: ' +
              File(decFilepath).readAsStringSync() +
              '\n');
          emit(AppDecryptionFileSuccessState());
        } on AesCryptException catch (e) {
          if (e.type == AesCryptExceptionType.destFileExists) {
            print(
                'decryption failed');
            print(e.message);
            emit(AppDecryptionFileErrorState(e.toString()));
          }
        }
        // _decryptFile(newFile);
      } else {
        print('need for permission');
        getStoragePermission();
      }

  }
}