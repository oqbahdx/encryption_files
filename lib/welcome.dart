import 'package:flutter/material.dart';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
class Welcome extends StatefulWidget {

  static String id = "Welcome";

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  TextEditingController tec = TextEditingController();
  var encryptedText,plainText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed:(){

            },
           child: Text('Encrypted'),
           ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed:(){

            },
              child: Text('Decrypted'),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: tec,
            ),
            SizedBox(height: 20,),
            Text('Plain Text',style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 20,),
            Text(plainText == null ? "":plainText),
            SizedBox(height: 50,),
            Text('Encrypted Text',style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 20,),
            Text(encryptedText == null ? "": encryptedText is encrypt.Encrypted ? encryptedText.base46:encryptedText),
          ],
        ),
      )
    );
  }
}
