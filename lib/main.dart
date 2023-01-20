import 'dart:async';

import 'package:authx_cs_usj/screens/addService_page.dart';
import 'package:authx_cs_usj/screens/filterService_page.dart';
import 'package:authx_cs_usj/screens/login_page.dart';
import 'package:authx_cs_usj/screens/qrScan_page.dart';
import 'package:authx_cs_usj/size_cofig.dart';
import 'package:authx_cs_usj/userSimplePreferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    //preferredOrientations();
  }

  // Future preferredOrientations() async{
  //   await SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp
  //   ]);
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OLS Video App',
        theme: ThemeData(
          accentColor: Colors.transparent,
          primarySwatch: Colors.blue,
        ),
        home:CheckAuth()
    );
  }

}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  late Timer _timer;
  bool isAuth = false;
  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn(){
    var token = UserSimplePreferences.getToken();
    if(token != null){
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = QRCodeScan();
    } else {
      child = FilterService();
    }
    return child;
  }

}
