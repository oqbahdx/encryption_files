
import 'package:encryptionfiles/bloc/bloc.dart';
import 'package:encryptionfiles/const/widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import 'encryption_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'encFiles',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final _auth = LocalAuthentication();
  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      showMessage(msg: 'please add security setting');

      return false;
    }
  }
  Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
    try {
      return await _auth.authenticate(
          localizedReason: 'use your finger print',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print("err $e");
      return false;
    }
  }

  Future showFingerPrint() async {
    final isAuthenticated = await authenticate();
    if (isAuthenticated) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => EncryptionPage()));
    }
  }

  @override
  void didChangeDependencies() {
    showFingerPrint();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(""),
      ),
    );
  }
}
