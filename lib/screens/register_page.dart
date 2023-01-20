import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../api.dart';
import '../size_cofig.dart';
import 'addService_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? firstName = "";
  String? lastName = "";
  String? password = "";
  String? username = "";
  String? email = "";
  String? company = "";
  String? role = "";

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
                    child: registerText()
                )
              ],
            ),
            buildRegister()
          ],
        ),
      ),
    );
  }

  Widget registerText()=>Text(
    "HELLO THERE...!",
    style: TextStyle(
        color: Colors.white,
        fontSize: 30
    ),
  );

  Widget buildRegister()=>Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 200,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "First Name",
                        filled: true,
                        fillColor: Color(0xffaa9cb8),
                      ),
                      onSaved: (text){
                        this.firstName = text;
                      },
                      validator: (text){
                        if(text == ""){
                          return "Please enter firstName";
                        }else{
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        filled: true,
                        fillColor: Color(0xffaa9cb8),
                      ),
                      onSaved: (text){
                        this.lastName = text;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email Address",
                        filled: true,
                        fillColor: Color(0xffaa9cb8),
                      ),
                      onSaved: (text){
                        this.email = text;
                      },
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
                        hintText: "Username",
                        filled: true,
                        fillColor: Color(0xffaa9cb8),
                      ),
                      onSaved: (text){
                        this.username = text;
                      },
                      validator: (text){
                        if(text == ""){
                          return "Please enter username";
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
                      ),
                      onSaved: (text){
                        this.password = text;
                      },
                      validator: (text){
                        if(text == ""){
                          return "Please enter password";
                        }else{
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Company",
                        filled: true,
                        fillColor: Color(0xffaa9cb8),
                      ),
                      onSaved: (text){
                        this.company = text;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Role",
                        filled: true,
                        fillColor: Color(0xffaa9cb8),
                      ),
                      onSaved: (text){
                        this.role = text;
                      },
                      validator: (text){
                        if(text == ""){
                          return "Please enter role";
                        }else{
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            )
        ),

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
              'REGISTER',
              style: TextStyle(
                  color: Colors.white,
                  fontSize:30
              ),
            ),
          ),
          onTap: () async{
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context){
            //           return AddService();
            //         }
            //     )
            // );
            setState(() {
              _formKey.currentState!.save();
              _register();
            });
            // if(_formKey.currentState.validate()){
            //   FocusScope.of(context).requestFocus(FocusNode());
            //   //bool isConnected = await InternetConnectionChecker().hasConnection;
            //   // var connectivityResult = await (Connectivity().checkConnectivity());
            //   // print(connectivityResult);
            //   // try {
            //   //   final result = await InternetAddress.lookup('http://localhost:58818');
            //   //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            //   //     print('connected');
            //   //   }
            //   // } on SocketException catch (_) {
            //   //   print('not connected');
            //   // }
            //   setState(() {
            //     //isLoading = true;
            //     //_formKey.currentState.save();
            //     //_login();
            //     // if(connectivityResult == ConnectivityResult.wifi){
            //     //   _formKey.currentState.save();
            //     //   _login();
            //     // }else{
            //     //   CheckConnectivity().showConnectivityBottomSheet(context);
            //     // }
            //   });
            // }
            // showModalBottomSheet(
            //     context: context,
            //     builder: (builder) => bottomSheet(context)
            // );
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
                "Already have account?",
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
                            return LoginPage();
                          }
                      )
                  );
                },
                child: Text(
                  "Login Account",
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
  );

  Future<void> _register() async{
    // var data = {
    //   'email': this.email,
    //   'password': this.password
    // };
    var data = {
      "firstName": "Vishwajith",
      "lastName": "Weerasinghe",
      "email": "vish.drck@gmail.com",
      "username": "vishdrck",
      "password": "123456",
      "company": "DevX Technologies",
      "role": "admin"
    };

    var res = await NetworkRequest().register(data);
    var body = json.decode(json.decode(res)); //convert into an array
    if(body['status'] == 'success'){
      showModalBottomSheet(
          context: context,
          builder: (builder) => bottomSheet(context)
      );
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
