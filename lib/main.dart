import 'package:flutter/material.dart';
import 'utente/pagine/dettagli_animale.dart';
import 'utente/pagine/login.dart';
import 'utente/pagine/dashboard.dart';

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