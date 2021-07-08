import 'package:encryptionfiles/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
// This widget is the root of your application.
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

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
    try {
      return await _auth.authenticate(
          localizedReason: 'enter your finger print',
          stickyAuth: true,
          useErrorDialogs: true);
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future showFingerPrint()async{
    final isAuthenticated = await authenticate();
    if(isAuthenticated){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context)=>Welcome()));
  }}

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
