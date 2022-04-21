import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taass_frontend_android/utente/pagine/dashboard.dart';

import '../../model/utente.dart';
import '../service/utente_service.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }
}

class LoginScreenState extends State<Login>{

  Map? _userData;
  String? nome;
  String? email;
  UtenteService httpService = UtenteService();
  GoogleSignIn googleSignIn = GoogleSignIn(clientId: "544771957287-ptg72gfe8kv4lql82u8lorg53qt0j5eb.apps.googleusercontent.com");

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Login")),
      body: Container(
        margin: EdgeInsets.all(95),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 150,
                width: 250,
                child: Center(
                  child: Image.asset('assets/images/pet_life_logo_idea_2.png'),
                ),
              ),
              SizedBox(height: 50),
              SignInButton(
                Buttons.Google,
                text: "Accedi con Google",
                onPressed: () {
                  SignIn("Google");
                },
              ),
              SizedBox(height: 20),
              SignInButton(
                Buttons.Facebook,
                text: "Accedi con Facebook",
                onPressed: () {
                  SignIn("Facebook");
                },
              )
              // ignore: deprecated_member_use, deprecated_member_use
            ],
          ),),
      ),
    );
  }

  void SignIn(String s) async{
    if(s == "Google"){
      var user = await googleSignIn.signIn();
      nome = user?.displayName;
      email = user?.email;
      Utente utente = new Utente(0, nome!, email!,[]);
      utente = await httpService.getUtente(utente);
      Navigator.push(context, new MaterialPageRoute(builder: (__) => new Dashboard(utente)));
    } else if (s == "Facebook"){
      final result = await FacebookAuth.i.login(
        permissions: ["public_profile", "email"]
      );
      if(result.status == LoginStatus.success){
        _userData = await FacebookAuth.i.getUserData(
          fields: "email,name"
        );
        var user = _userData?.values.toList();
        Utente utente = new Utente(0,user![1],user[0],[]);
        utente = await httpService.getUtente(utente);
        Navigator.push(context, new MaterialPageRoute(builder: (__) => new Dashboard(utente)));
      }
    }

  }
}
