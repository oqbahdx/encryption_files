import 'dart:io';
import 'dart:ui';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:encryptionfiles/bloc/bloc.dart';
import 'package:encryptionfiles/bloc/states.dart';
import 'package:encryptionfiles/const/colors.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'const/widgets/containers.dart';

class EncryptionPage extends StatefulWidget {
  @override
  _EncryptionPageState createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage> {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    cubit.getStoragePermission();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'DX ENCRYPTION',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: gradientColors,
                )),
              ),
            ),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  ConditionalBuilder(
                    condition: state is! AppEncryptionFileLoadingState,
                    builder: (context) => defaultContainer(
                        txt: 'Select File To Encrypt',
                        h: _height * 0.095,
                        onTap: () async{
                          if (await Permission.storage.request().isGranted) {
                            cubit.encryptionFile();
                          }
                        }),
                    fallback: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.1,
                  ),
                  ConditionalBuilder(
                    condition: state is! AppDecryptionFileLoadingState,
                    builder: (context) =>  defaultContainer(
                        txt: 'Select File To Decrypt',
                        h: _height * 0.095,
                        onTap: () {
                          cubit.decryptionFile();
                        }),
                    fallback: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
