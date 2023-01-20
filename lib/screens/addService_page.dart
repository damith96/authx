import 'dart:async';

import 'package:authx_cs_usj/screens/qrScan_page.dart';
import 'package:flutter/material.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {

  late Timer _timer;
  String meridiem = '';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) => setState(() {}));
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

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context){
                    return QRCodeScan();
                  }
              )
          );
        },
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
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                children:[
                  Text(
                    "You don't have any services",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:20
                    ),
                  ),
                  Text(
                    'connected to AuthX',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:20
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Use',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:20
                        ),
                      ),
                      SizedBox(width: 10),
                      Image.asset("assets/images/addIcon.png"),
                      SizedBox(width: 10),
                      Text(
                        'button to',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:20
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'add a service to AuthX',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:20
                    ),
                  ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _addAService() async{
    
  }
}
