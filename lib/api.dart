import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:authx_cs_usj/userSimplePreferences.dart';

import 'encryptDecrypt.dart';

class NetworkRequest{

  //final String _url = 'http://localhost:8000/api/v1'; //BASE_URL for our Laravel API
  final String _url = 'https://authx.yaatter.xyz';
  //final String _url = 'http://localhost:1998';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  Future login(data) async{
    var fullUrl = _url + '/api/login';
    final String recData = json.encode(data);
    var encrptedText = EncryptDecrypt().encryptAESCryptoJS(recData);
    var sendData = this.sendJson(encrptedText);
    var res = await http.post(
        Uri.parse(fullUrl),
        body: json.encode(sendData),
    );
    var body = jsonDecode(res.body);
    var decryptedText = EncryptDecrypt().decryptAESCryptoJS(body['data']);
    return decryptedText;

  }

  Future register(data) async{
    var fullUrl = _url + '/api/register';
    final String recData = json.encode(data);
    var encrptedText = EncryptDecrypt().encryptAESCryptoJS(recData);
    var sendData = this.sendJson(encrptedText);
    var res = await http.post(
      Uri.parse(fullUrl),
      body: json.encode(sendData),
    );
    var body = jsonDecode(res.body);
    var decryptedText = EncryptDecrypt().decryptAESCryptoJS(body['data']);
    return decryptedText;
  }

  Future addAService(data) async{
    var fullUrl = _url + '/api/user/service/register';
    getToken();
    final String recData = json.encode(data);
    var encrptedText = EncryptDecrypt().encryptAESCryptoJS(recData);
    var sendData = this.sendJson(encrptedText);
    var res = await http.post(
        Uri.parse(fullUrl),
        body: json.encode(sendData),
        headers: _setHeaders()
    );
  }

  void getToken(){
    token = UserSimplePreferences.getToken();
  }

  Future getAllSerivceByUserId(String? id) async{
    var fullUrl = _url + '/api/user/$id/services';
    getToken();
    var res = await http.get(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
    var body = jsonDecode(res.body);
    var decryptedText = EncryptDecrypt().decryptAESCryptoJS(body['data']);
    return decryptedText;
  }

  Future authenticateSpecificLoginRequest(String _sid) async{
    var fullUrl = _url + '/api/user/$_sid/authenticate';
    getToken();
    var res = await http.get(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
    // var body = jsonDecode(res.body);
    // var decryptedText = EncryptDecrypt().decryptAESCryptoJS(body['data']);
    // return decryptedText;
  }

  Future putData(apiUrl) async{
    var fullUrl = _url + apiUrl;
    getToken();
    return await http.put(
        Uri.parse(fullUrl),
        headers: _setHeaders()
    );
  }
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };

  sendJson(text){
    return {
      'data':text
    };
  }
}