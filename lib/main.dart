import 'package:flutter/material.dart';
import 'package:testingflutterapp/pages/SecondPage.dart';
import './pages/FirstPage.dart';
import 'pages/ThirdPage.dart';

void main() => runApp(KidsKeeper());

class KidsKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home : SecondPage());
  }
}