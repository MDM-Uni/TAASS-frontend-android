import 'package:flutter/material.dart';
import 'pagine/dettagli_animale.dart';
import 'pagine/login.dart';
import 'pagine/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coding with Johnnie',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Login(),
    );
  }
}