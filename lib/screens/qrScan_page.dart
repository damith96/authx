import 'dart:async';
import 'dart:io';

import 'package:authx_cs_usj/userSimplePreferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../api.dart';
import '../search_widget.dart';
import '../size_cofig.dart';

class QRCodeScan extends StatefulWidget {
  const QRCodeScan({Key? key}) : super(key: key);

  @override
  _QRCodeScanState createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;

  late Timer _timer;
  bool hasInternet = false;
  String query = '';
  List<String> list = [];
  List<String> visibleList = [];
  bool dataAdded = false;
  int count = 0;
  String meridiem = '';

  List resList = [];
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) => setState(() {}));
    //loadData();
  }

  @override
  void dispose() {
    controller?.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if(Platform.isAndroid){
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: <Widget>[
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
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              height: 80,
              child: Text(
                "Place the QR code in the below camera area",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: buildQrView(context),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 0),
              child: TextButton(
                onPressed: (){
                  setState(() {
                  });
                },
                child: Text(
                  "GET STARTED",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:24
                  ),
                ),),
            )
          ],
        ),
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
    key: qrKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
      borderRadius: 10,
      borderLength: 20,
      borderWidth: 10,
      cutOutSize: MediaQuery.of(context).size.width * 0.7,
    ),
  );

  void onQRViewCreated(QRViewController controller){
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      this.barcode = barcode;
      //_addAService(sId)
    });
  }

  Future<void> _addAService(String sId) async{
    var uId = UserSimplePreferences.getId();
    var data = {
      '_uid':uId,
      '_sid':sId
    };
    var res = await NetworkRequest().addAService(data);
  }
}
