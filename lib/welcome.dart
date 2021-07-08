import 'package:encryptionfiles/my_encryption_files.dart';
import 'package:flutter/material.dart';
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
              plainText = tec.text;
              setState(() {
                encryptedText = MyEncryption.encryptFernet(plainText);
              });
            },
           child: Text('Encrypted'),
           ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed:(){
              setState(() {
                encryptedText = MyEncryption.decryptFernet(encryptedText);
              });
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
            Text(encryptedText == null ? "": encryptedText is encrypt.Encrypted ? encryptedText.base64:encryptedText),
          ],
        ),
      )
    );
  }
}
