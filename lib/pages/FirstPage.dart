import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:isolate';
import 'dart:ui';

import '../src/AlertDialog.dart';
import '../src/ChildCard.dart';
import '../src/Server.dart';
import '../models/ParentsKids.dart';
import '../db/KikeeDB.dart';
import './SecondPage.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController keyController = new TextEditingController();

  List<String> childList;

  //isolate variables (start)
  Isolate _isolate;
  bool _running = false;
  static int _counter = 0;
  String notification = "";
  ReceivePort _receivePort;
  //isolate variables (finish)

  Future<bool> _getNameList() async {
    List<String> nameList = await KikeeDB.instance.getParentsKidsName();
    childList = nameList;
    return true;
    //setState(() {});
  }

  initState() {
    super.initState();
    _start();
  }

  int selectIdx = 0;

  @override
  Widget build(BuildContext context) {
    if (_running != true) {
      return Scaffold(
        backgroundColor: Color(0xfffcefa3),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('KIKEE', style: TextStyle(fontFamily: 'BMJUA',
                      fontSize: 70,
                      color: Colors.orange),),
                  Image.asset('image/KIKI.png', height: 57,),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: 120,
                          padding: EdgeInsets.all(15),
                          child: Text('추가', style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'BMJUA',
                              fontSize: 20), textAlign: TextAlign.center,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(15.0)),
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          Alert(
                              context: context,
                              title: "자녀 추가",
                              style: AlertStyle(
                                titleStyle: TextStyle(fontFamily: 'BMJUA',
                                    fontSize: 30,
                                    color: Colors.orange),
                                alertBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              content: Column(
                                children: <Widget>[
                                  SizedBox(height: 30,),
                                  CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Color(0xfffff3e3),
                                    child: Icon(
                                      Icons.person, color: Color(0xffffcf91),
                                      size: 120,),
                                  ),
                                  SizedBox(height: 20,),
                                  Material(
                                    elevation: 5.0,
                                    color: Colors.white,
                                    shadowColor: Color(0xffe0e0e0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                          children: <Widget>[
                                            TextField(
                                              controller: nameController,
                                              //입력받는 controller
                                              style: TextStyle(
                                                color: Color(0xfff0ae75),
                                                fontSize: 18,
                                                fontFamily: 'BMJUA',),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: " 자녀의 이름을 입력해 주세요",
                                                  hintStyle: TextStyle(
                                                    color: Color(0xfff0ae75),
                                                    fontSize: 18,
                                                    fontFamily: 'BMJUA',)),
                                            ),
                                            TextField(
                                              controller: keyController,
                                              //입력받는 controller
                                              style: TextStyle(
                                                color: Color(0xfff0ae75),
                                                fontSize: 18,
                                                fontFamily: 'BMJUA',),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: " 키를 입력해 주세요",
                                                  hintStyle: TextStyle(
                                                    color: Color(0xfff0ae75),
                                                    fontSize: 18,
                                                    fontFamily: 'BMJUA',)),
                                            ),
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  color: Colors.orange,
                                  radius: BorderRadius.circular(10),
                                  onPressed: () async
                                  {
                                    String name = nameController.text;
                                    String key = keyController.text;

                                    int result = await KikeeDB.instance
                                        .insertParentsId(name, key);
                                    print('result: ' + result.toString());

                                    if (result == 1) {
                                      childList.add(name);
                                      setState(() {});
                                      Navigator.pop(context);
                                    }
                                    else if (result == 0) {
                                      print('FirstPage: key is invaild');
                                      Navigator.pop(context);
                                      showMyDialog(context, "코드가 올바르지 않습니다.");
                                    }
                                  },
                                  child: Text(
                                    "확인",
                                    style: TextStyle(color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'BMJUA',),
                                  ),
                                )
                              ]).show();
                        },

                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        child: Container(
                          width: 120,
                          padding: EdgeInsets.all(15),
                          child: Text('삭제', style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'BMJUA',
                              fontSize: 20), textAlign: TextAlign.center,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(15.0)),
                            color: Colors.orange,
                          ),
                        ),
                        onTap: () {
                          alertKidsDeleteDialog(context, '자녀 목록');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Container(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: childList.length, //슬라이드 카드 정보 리스트
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        child: childCard(childList[index]),
                        onTap: () async {
                          int kidsId = await KikeeDB.instance.getParentsKidsId(
                              index);
                          await kidsLocationGet(1, kidsId);
                          print("FirstPage: onTap linstend!");
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => MapPage(kidsId)));
                        },
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }else{
      return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient:LinearGradient(
                  begin: Alignment.topCenter,
                  end:Alignment.bottomCenter,
                  colors: [Color(0xfffcf2a3),Color(0xfffed7a1)]),
                image: DecorationImage(
                  image: AssetImage('image/KIKI.png'),
                )
            ),
        ),
      );
    }
  }

//isolate start
  void _start() async {
    _running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone:() {
      print("isolate (LoadingScreen) done!");
    });
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 3), (Timer t) { //3초마다 확인.
      _counter++;
      String msg = 'notification ' + _counter.toString();
      print('SEND: ' + msg);
      sendPort.send(msg);
    });
  }

  void _handleMessage(dynamic data) async {
    //print('RECEIVED: ' + data);
    notification = data;
    var result = false;
    if(data == "notification 1"){ //첫 시도에만 setPolylines함수 호출.
      result = await _getNameList(); //result에 값 받길 기다림. 하지만, 여기서 멈추지 않고 _checkTimer->_handleMessage 계속 실행
    }
    if(result == true){//첫번째 시도에서 결국 result값이 받아졌다면 stop됨.
      _stop();
    }
    if(data == null || data =="notification 60"){
      _stop();
    }

  }

  String textConvert(String text)
  {
    if(text.length>9){
      return text.substring(0,9)+"...";
    }
    else return text;
  }
  void _stop() {
    if (_isolate != null) {
      if( this.mounted ) {
        setState(() {
          _running = false;
          notification = '';
        });
      }
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
//isolate done
  Future<void> alertKidsDeleteDialog( BuildContext context, String msg ) async {
    return Alert(
      context: context,
      title: msg,
      content: Container(
        height: 300.0,
        width: 300.0,
        child:
          FutureBuilder<List<ParentsKids>>(
            future: KikeeDB.instance.getParentsKids(),
            builder: (context, snapshot) {
              if( snapshot.hasData ) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: ( BuildContext context, int index ) {
                    return ListTile(
                      title: Text( snapshot.data[index].name, style: TextStyle(fontFamily: 'BMJUA', color: Color(0xffe09a4f), fontWeight: FontWeight.bold, fontSize: 20.0) ),
                      trailing: IconButton(
                        alignment: Alignment.center,
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          KikeeDB.instance.deleteParentsKidsId( snapshot.data[index].id );
                          Navigator.pop(context);
                          _getNameList();
                        },
                      ),
                    );
                  },
                );
              }
              else if( snapshot.hasError ) return Text('eror');
              else return Center( child: CircularProgressIndicator() );
            },
          )
      ),
      style: AlertStyle(
        titleStyle: TextStyle( fontFamily: 'BMJUA',color: Colors.black,fontSize: 20),
        backgroundColor: Color(0xfffdfbf4),
        alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0),),
        ),
      ),
      buttons: [
        DialogButton(
            color: Color(0xfff7b413),
            radius: BorderRadius.circular(15),
            onPressed: () {
              Navigator.pop(context);
            },
            child:
            Text("확인", style: TextStyle(color: Colors.white, fontSize: 20,fontFamily: 'BMJUA'))
        ),
      ],
      closeFunction: ()=>{} //it's nothing but if you deleted this, errors appear.
    ).show();
  }
}