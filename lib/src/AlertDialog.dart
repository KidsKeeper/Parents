import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<void> showMyDialog(BuildContext context,String msg) async{
  return Alert(
      context: context,
      title: msg,
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
            Text("네", style: TextStyle(color: Colors.white, fontSize: 20,fontFamily: 'BMJUA'))
        ),
      ],
      closeFunction: ()=>{} //it's nothing but if you deleted this, errors appear.
  ).show();
}