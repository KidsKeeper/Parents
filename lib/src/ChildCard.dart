import 'package:flutter/material.dart';

Widget childCard(String name)
{
  return Container(
    margin: EdgeInsets.all(25),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0xffe5d877),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]),
    child: Container(
      padding: EdgeInsets.all(20) ,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xfffff3e3),
            child: Icon(Icons.person,color: Color(0xffffcf91),size: 80,),
          ),
          SizedBox(height: 20),
          Container(
            width: 110,
            padding: EdgeInsets.all(10),
            child: Text(name,style:TextStyle(fontFamily: 'BMJUA',fontSize: 20,color: Color(0xffffcf91)),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffe0e0e0),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
          ),
        ],
      ),
    ),
  );
}
