import 'dart:convert';

import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:tuple/tuple.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptDecrypt{

  //how to convert any length key to 128 bit format
  //"For AES, NIST selected three members of the Rijndael family,
  // each with a block size of 128 bits, but three different key lengths: 128, 192 and 256 bits. "

  static const secretKey = "vOVH6sdmpNWjRRIqCc7rdxs01lwHzfr3"; //32
  // static final key = encrypt.Key.fromUtf8(secretKey); //128 bit key
  // static final iv = encrypt.IV.fromUtf8(8); //initialization vector
  // static final iv = encrypt.IV.fromUtf8(secretKey);
  // static final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.ecb));

  // static encryptAes(String text){
  //   final encrypted = encrypter.encrypt(text);
  //   return encrypted.base64;
  // }
  //
  static decryptAes(String encrypted){
    //Encrypted data - U2FsdGVkX1/boEIMr5jtqvKCsC31P7mjdGAB4CQGVpHnskSV3mvJ9cRrzElUre0hbm0HvLOcVmnwrQLxrjuRFkdRf7iQPA+1dtZ+d536S3QXct63t0oxoe9odpA+dY65
    Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

    Uint8List encryptedBytes =
    encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
     //String encoded = base64.encode(utf8.encode(text));
    //convert.utf8.encode(input)
    //var encrypted = text as encrypt.Encrypted;
    //print(encoded);
    //final decrypted = encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
    //final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(text),iv: iv);
    //return decrypted;
  }

  String encryptAESCryptoJS(String plainText, {passphrase = secretKey}) {
    try {
      final salt = genRandomWithNonZero(8);
      var keyndIV = deriveKeyAndIV(passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      // static final key = encrypt.Key.fromUtf8(secretKey);
      // static final iv = encrypt.IV.fromUtf8(secretKey);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      Uint8List encryptedBytesWithSalt = Uint8List.fromList(
          createUint8ListFromString("Salted__") + salt + encrypted.bytes);
      return base64.encode(encryptedBytesWithSalt);
    } catch (error) {
      throw error;
    }
  }

  String decryptAESCryptoJS(String encrypted, {passphrase = secretKey}) {
    try {
      Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

      Uint8List encryptedBytes =
      encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
      final salt = encryptedBytesWithSalt.sublist(8, 16);
      var keyndIV = deriveKeyAndIV(passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final decrypted =
      encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
      return decrypted;
    } catch (error) {
      throw error;
    }
  }

  Tuple2<Uint8List, Uint8List> deriveKeyAndIV(String passphrase, Uint8List salt) {
    var password = createUint8ListFromString(passphrase);
    Uint8List concatenatedHashes = Uint8List(0);
    Uint8List currentHash = Uint8List(0);
    bool enoughBytesForKey = false;
    Uint8List preHash = Uint8List(0);

    while (!enoughBytesForKey) {
      int preHashLength = currentHash.length + password.length + salt.length;
      if (currentHash.length > 0)
        preHash = Uint8List.fromList(
            currentHash + password + salt);
      else
        preHash = Uint8List.fromList(
            password + salt);

      currentHash = md5.convert(preHash).bytes as Uint8List;
      concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
      if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
    }

    var keyBtyes = concatenatedHashes.sublist(0, 32);
    var ivBtyes = concatenatedHashes.sublist(32, 48);
    return new Tuple2(keyBtyes, ivBtyes);
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  Uint8List genRandomWithNonZero(int seedLength) {
    final random = Random.secure();
    const int randomMax = 245;
    final Uint8List uint8list = Uint8List(seedLength);
    for (int i=0; i < seedLength; i++) {
      uint8list[i] = random.nextInt(randomMax)+1;
    }
    return uint8list;
  }
}