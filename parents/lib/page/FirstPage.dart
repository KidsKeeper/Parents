import 'dart:ui';
//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xfffcefa3),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('KIKEE',style: TextStyle(fontFamily: 'BMJUA',fontSize: 70,color: Colors.orange) ,),
                Image.asset('image/_304.png',height: 57,),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: FlatButton(
                    child: Text('내 자녀 코드 입력하기',style: TextStyle(color: Colors.white,fontFamily: 'BMJUA',fontSize: 20),),
                    onPressed: () => print("pressed"),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffe5d877),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                ),
              ],
            ),
            SizedBox(
              height: 45,
            ),
          ],
        ),
      ),
    );
  }
}