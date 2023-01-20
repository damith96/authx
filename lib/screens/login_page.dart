import 'dart:convert';

import 'package:authx_cs_usj/screens/qrScan_page.dart';
import 'package:authx_cs_usj/screens/register_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../api.dart';
import '../encryptDecrypt.dart';
import '../size_cofig.dart';
import '../userSimplePreferences.dart';
import 'addService_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email = "";
  String? password = "";
  bool isLogin = true;
  bool isVerificationFailed = false;

  @override
  Widget build(BuildContext context) {
    SizedConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Container(
                  height: 300,
                  width: double.maxFinite,
                ),
                Positioned(
                  top: -100,
                  //left: 10.0,
                  child: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/images/group.png",
                      fit: BoxFit.cover,
                    ),
                  )
                ),
                Positioned(
                  left:30,
                  bottom: 0,
                  child: loginText()
                )
              ],
            ),
            if(isVerificationFailed) Container(
                margin: EdgeInsets.only(left: 30,right: 30,top: 10),
                color: Colors.red,
                height: 8.5*SizedConfig.heightMultiplier,
                child:Row(
                    children:[
                      Padding(
                        padding:EdgeInsets.only(right: 4*SizedConfig.widthMultiplier,left: 4*SizedConfig.widthMultiplier),
                        child: Icon(FontAwesomeIcons.exclamationTriangle,size: 4*SizedConfig.heightMultiplier,color: Colors.white),
                      ),
                      Text(
                        'Authentication failed!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 3*SizedConfig.heightMultiplier,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ]
                )
            ),
            buildLogin()
          ],
        ),
      ),
    );
  }

  Widget loginText()=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
          clipBehavior: Clip.none,
          children:[
            Text(
              "WELCOME BACK",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30
              ),
            ),
            Positioned(
              right: -10,
              top: -5,
              child: Image(
                image: AssetImage("assets/images/target.png"),
                height: 20,
                width: 20,
              ),
            )
          ]
      ),
      Text(
        "Enter your email & password to login",
        style: TextStyle(
          color: Colors.white30,
        ),
      ),
    ],
  );

  Widget buildLogin()=>Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isVerificationFailed ? SizedBox(height: 10,): SizedBox(height: 20,),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Email Adderss",
              filled: true,
              fillColor: Color(0xffaa9cb8),
              errorStyle: TextStyle(fontSize: 2*SizedConfig.heightMultiplier),
            ),
            onSaved: (text){
              this.email = text;
            },
            cursorColor: Colors.white,
            validator: (text){
              if(text == ""){
                return "Please enter email";
              }else{
                return null;
              }
            },
          ),
          SizedBox(height: 20,),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Password",
              filled: true,
              fillColor: Color(0xffaa9cb8),
              errorStyle: TextStyle(fontSize: 2*SizedConfig.heightMultiplier)
            ),
            onSaved: (text){
              this.password = text;
            },
            cursorColor: Colors.white,
            validator: (text){
              if(text == ""){
                return "Please enter password";
              }else{
                return null;
              }
            },
          ),
          SizedBox(height: 20,),
          InkWell(
            child: Container(
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(8),
                color: Colors.blueAccent,
              ),
              width: double.infinity,
              child: Text(
                'LOGIN',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:30
                ),
              ),
            ),
            onTap: () async{
              // if(_formKey.currentState!.validate()){
              //   FocusScope.of(context).requestFocus(FocusNode());
              //   setState(() {
              //     _formKey.currentState!.save();
              //     //_login();
              //   });
              // }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context){
                        return AddService();
                      }
                  )
              );
              // setState(() {
              //     _formKey.currentState!.save();
              //     _login();
              // });
            },
          ),
          SizedBox(height: 30,),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Don't have account?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:20
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context){
                              return RegisterPage();
                            }
                        )
                    );
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:20
                    ),
                  ),)
              ],
            ),
          )

        ],
      ),
    ),
  );

  Future<void> _login() async{
    // var data = {
    //   'email': this.email,
    //   'password': this.password
    // };
    var data = {
      "email": "vish.drck@gmail.com",
      "password": "123456"
    };

    var res = await NetworkRequest().login(data);
    var body = json.decode(json.decode(res)); //convert into an array
    if(body['status'] == 'success'){
      var data = body['data'];
      await UserSimplePreferences.setId(data['_id']);
      await UserSimplePreferences.setUserName(data['username']);
      await UserSimplePreferences.setFirstName(data['firstName']);
      await UserSimplePreferences.setLastName(data['lastName']);
      await UserSimplePreferences.setEmail(data['email']);
      await UserSimplePreferences.setRole(data['role']);
      await UserSimplePreferences.setToken(data['token']);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context){
                return AddService();
              }
          )
      );
    }else{
      setState(() {
        this.isVerificationFailed = true;
      });
    }
  }

  Widget bottomSheet(BuildContext context){
    return Container(
      height: 50*SizedConfig.heightMultiplier,
      decoration: BoxDecoration(
          //borderRadius: BorderRadius.only(topRight: Radius.circular(3*SizedConfig.heightMultiplier),topLeft: Radius.circular(3*SizedConfig.heightMultiplier)),
          color: Colors.black
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/well_done.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 1.5*SizedConfig.heightMultiplier,bottom: 1.5*SizedConfig.heightMultiplier),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                AutoSizeText(
                  'Registration Successfull',
                  style: TextStyle(
                      fontSize: 3.8*SizedConfig.heightMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 1.5*SizedConfig.heightMultiplier,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: AutoSizeText(
                    'You have successfully registered to AuthX',
                    style: TextStyle(
                        fontSize: 2.5*SizedConfig.heightMultiplier,
                        color: Colors.white30
                    ),
                    textAlign:TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 1.5*SizedConfig.heightMultiplier,),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 8*SizedConfig.widthMultiplier),
                    padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizedConfig.heightMultiplier),
                      color: Color(0xff336BFF),
                    ),
                    child: Text("Okay",style: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,fontWeight: FontWeight.w800,color: Colors.white)),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
