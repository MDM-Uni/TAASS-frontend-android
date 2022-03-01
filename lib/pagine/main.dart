import 'package:flutter/material.dart';
import 'dettaglianimale.dart';
import 'login.dart';
import 'dashboard.dart';

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
      home: DettagliAnimale(),
    );
  }
}