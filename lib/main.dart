
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'encryption_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final _auth = LocalAuthentication();
 //هنا للتأكد من ان الهاتف يملك قارئ بصمه
  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'الرجاء تفعيل اعدادات الامان',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return false;
    }
  }
  // هنا الداله التي تقوم بالتحقق من البصمه بدايه فتح التطبيق
  Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
    try {
      return await _auth.authenticate(
          localizedReason: 'افتح عن طريق بصمتك',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print("err $e");
      return false;
    }
  }
  // بعد التأكد من صحه البصمه يتم الذهاب الى الصفحه الرئيسيه
  Future showFingerPrint() async {
    final isAuthenticated = await authenticate();
    if (isAuthenticated) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => EncryptionPage()));
    }
  }
  // اظهار رساله ادخال البصمه لحظه فتح التطبيق
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
