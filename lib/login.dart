import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }
}

class LoginScreenState extends State<Login>{

  String? name;
  String? email;
  GoogleSignIn googleSignIn = GoogleSignIn(clientId: "544771957287-ptg72gfe8kv4lql82u8lorg53qt0j5eb.apps.googleusercontent.com");

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Login")),
      body: Container(
        margin: EdgeInsets.all(80),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
      name = user?.displayName;
      email = user?.email;
      print(name! + " " + email!);
    } else if (s == "Facebook"){

    }

  }
}
