import 'package:flutter/material.dart';

import 'dart:ui';

import 'SecondPage.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TextEditingController controller = new TextEditingController(); //Textfield controller for code input
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xfffcefa3),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('KIKEE',style: TextStyle(fontFamily: 'BMJUA',fontSize: 70,color: Colors.orange) ,),
                Image.asset('image/KIKI.png',height: 57,),
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
                  child: Text('코드를 입력해 주세요',style: TextStyle(color: Colors.white,fontFamily: 'BMJUA',fontSize: 20),),
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
                SizedBox(
                  width: 20,
                ),
                //Textfield for code input
                Container(
                  width: 100,
                  height: 50,
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: Colors.blue,fontFamily: 'BMJUA',fontSize: 20),),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.white,
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
              height: 30,
            ),
            MaterialButton(
              child: Text('건너뛰기',style: TextStyle(color: Color(0xFFF0AD74),fontFamily: 'BMJUA',fontSize: 17),) ,
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
