import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryption{

  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));


  static encryptAES(text){
  final encrypted = encrypter.encrypt(text,iv: iv);
  print(encrypted.bytes);
  print(encrypted.base16);
  print(encrypted.base64);
  return encrypted;
  }

  static decryptAES(text){
  return encrypter.decrypt(text,iv: iv);

  }

  static final keyFerent = encrypt.Key.fromUtf8("flutterOqbahDXflutterOqbahDXflut");
  static final fernet = encrypt.Fernet(keyFerent);
  static final encrypterFernet = encrypt.Encrypter(fernet);


  static encryptFernet(text){
    final encrypted = encrypterFernet.encrypt(text);
    print(fernet.extractTimestamp(encrypted.bytes));
    return encrypted;
  }

  static decryptFernet(text){

    return encrypterFernet.decrypt(text);

  }


  static final keySalsa20 = encrypt.Key.fromLength(32);
  static final ivSalsa20 = encrypt.IV.fromLength(8);
  static final encrypterSalsa20 = encrypt.Encrypter(encrypt.Salsa20(keySalsa20));

  static encryptSalsa20(text){
    return encrypterSalsa20.encrypt(text,iv: ivSalsa20);

  }

  static decryptSalsa20(text){
    return encrypterSalsa20.decrypt(text,iv: ivSalsa20);

  }
}