import 'package:flutter/material.dart';

import 'page/FirstPage.dart';

void main() => runApp(KidsKeeper());

class KidsKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home : FirstPage());
  }
}