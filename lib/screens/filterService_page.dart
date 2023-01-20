import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

import '../api.dart';
import '../search_widget.dart';
import '../size_cofig.dart';
import '../userSimplePreferences.dart';

class FilterService extends StatefulWidget {
  const FilterService({Key? key}) : super(key: key);

  @override
  _FilterServiceState createState() => _FilterServiceState();
}

class _FilterServiceState extends State<FilterService> {
  late Timer _timer;
  final _auth = LocalAuthentication();
  bool hasInternet = true; //change to false
  String query = '';
  var list = [];
  var visibleList = [
  {
    "_uid":"62661913030ffa1bdf0889f8",
    "_sid":"62661acc030ffa1bdf0889ff",
    "isLoginAuthRequested":true,
    "isAuthenticated":false,
    "service_name":"Yatter Social Network"
  },
  {
    "_uid":"62661913030ffa1bdf0889f8",
    "_sid":"626626262e125e70ed4a607e",
    "isLoginAuthRequested":false,
    "isAuthenticated":false,
    "service_name":"Facebook"
  }];
  bool dataAdded = false;
  int count = 0;
  String meridiem = '';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) => setState(() {

    }));
    //loadAllServices();
  }

  Future<void> loadAllServices() async{
    await getAllServices();
    this.hasInternet = true;
    this.dataAdded = true;
    setState(() {});
  }

  Future<void> getAllServices() async{
    String? id = UserSimplePreferences.getId();
    var res = await NetworkRequest().getAllSerivceByUserId(id);
    var body = json.decode(json.decode(res));
    this.list = body['data'];
    // for(var i=0;i<this.count;i++){
    //   list.add(resList[i]['title']);
    // }
    //visibleList = list;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    if(00 <= now.hour && now.hour <12){
      this.meridiem = 'AM';
    }else{
      this.meridiem = 'PM';
    }

    SizedConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: (){},
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30,vertical: 50),
        child: Column(
          children: [
            Card(
              color: Colors.purple,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 80,
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      height: 80,
                      child: Text(
                        now.minute<10 ? '${now.hour}:0${now.minute} ${this.meridiem}':'${now.hour}:${now.minute} ${this.meridiem}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/small-top.png"),
                              fit: BoxFit.fitHeight
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
            buildSearch(),

            hasInternet
                ? visibleList.isNotEmpty
                  ? Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: visibleList.length,
                            itemBuilder: (context, index){
                              var bool = visibleList[index]['isLoginAuthRequested'];
                              var name = visibleList[index]['service_name'];
                              var _sid = visibleList[index]['_sid'];
                              return buildItems(bool, name, _sid, context);
                            }
                        )      ,
                      ),
                  )
                  : Expanded(
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Image(
                                  image: AssetImage("assets/images/404.png"),
                                  height: 29*SizedConfig.heightMultiplier,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Text('No Results Found!',style: TextStyle(fontSize: 4*SizedConfig.heightMultiplier,color: Colors.white,fontWeight: FontWeight.w500),),
                              SizedBox(height: 6*SizedConfig.heightMultiplier,),
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
                                      color: Color(0xff336BFF)
                                  ),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.arrowLeft,
                                        size: 5*SizedConfig.heightMultiplier,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 2.5*SizedConfig.widthMultiplier),
                                      Text(
                                        "Go Back",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 4*SizedConfig.heightMultiplier,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  )
                : Expanded(
                    child: Container(
                        child: Center(
                          child: SizedBox(
                              width: 6*SizedConfig.heightMultiplier,
                              height: 6*SizedConfig.heightMultiplier,
                              child: CircularProgressIndicator(strokeWidth: 5.0,)
                          ),
                        )
                    ),
                )
          ],
        ),
      ),
    );
  }

  Widget buildItems(bool, name, _sid, BuildContext context) {
    return Container(
      height: 22*SizedConfig.heightMultiplier,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
      padding: EdgeInsets.symmetric(vertical: SizedConfig.heightMultiplier,horizontal: SizedConfig.widthMultiplier),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
        color: bool ? Colors.purple[300] : Colors.black,
      ),
      child: ListTile(
        horizontalTitleGap: 30,
        leading: Container(
          width: 7*SizedConfig.heightMultiplier,
          height: 7*SizedConfig.heightMultiplier,
          child: Image.asset("assets/images/fbIcon.png"),
        ), //Change
        title: Text(
          name,
          style: TextStyle(
              color: Colors.white,
              fontSize: 4.5*SizedConfig.heightMultiplier
          ),
        ),
        trailing: Icon(Icons.settings,color: Colors.white,size: 40,),
        onTap: () async{
          if(bool){
            final isAuthenticated = await authenticate();
            if(isAuthenticated){
              NetworkRequest().authenticateSpecificLoginRequest(_sid);
            }
          }
        },
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Filter Service',
    onChanged: searchCourse,
  );


  void searchCourse(String query) {
    // visibleList = list.where((course) {
    //   final courseTitle = course['service_name'].toLowerCase();
    //   final searchTitle = query.toLowerCase();
    //
    //   return courseTitle.contains(searchTitle);
    // }).toList();

    setState(() {
      this.query = query;
    });

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

  Future<bool> authenticate() async{
    final isAvailable = await hasBiometrics();
    if(!isAvailable) return false;

    try{
      return await this._auth.authenticate(
        localizedReason: "Scan fingerprint to Authenticate",
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch(e){
      return false;
    }

  }

  Future<bool> hasBiometrics() async{
    try{
      return await _auth.canCheckBiometrics;
    }on PlatformException catch(e){
      return false;
    }
  }
}

