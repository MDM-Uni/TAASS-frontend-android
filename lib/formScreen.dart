import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen>{

  String? name;
  String? email;
  String? password;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildNameField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      validator: (String? value){
        if(value!=null && value.isEmpty){
          return 'Name is required';
        }
      },
      onSaved: (String? value){
        name = value!;
      },
    );
  }

  Widget buildEmailField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String? value){
        if(value!=null && value.isEmpty){
          return 'Email is required';
        }
      },
      onSaved: (String? value){
        email = value!;
      },
    );
  }

  Widget buildPasswordField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      validator: (String? value){
        if(value!=null && value.isEmpty){
          return 'Password is required';
        }
      },
      onSaved: (String? value){
        password = value!;
      },
    );
  }

  Container _buildFacebookLoginButton() {
    return Container(
      child: ButtonTheme(
        height: 48,
        child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onPressed: () {

            },
            color: Color.fromRGBO(27, 76, 213, 1),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textColor: Colors.white,
            child: const Text(
              "Connect with Facebook",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
      ),
    );
  }

  Container _buildGoogleLoginButton() {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
      child: ButtonTheme(
        height: 48,
        child: RaisedButton(
            onPressed: () {

            },
            color: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textColor: Color.fromRGBO(122, 122, 122, 1),
            child: Text("Connect with Google",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ))),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Login")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildNameField(),
              buildEmailField(),
              buildEmailField(),
              SizedBox(height: 100),
              // ignore: deprecated_member_use, deprecated_member_use
              RaisedButton(
                // ignore: prefer_const_constructors
                child: Text('Submit',style: TextStyle(color: Colors.blue, fontSize: 16,),),
                onPressed: (){
                  if(!formKey.currentState!.validate()){
                    return;
                  }
                  formKey.currentState!.save();
                },)
            ],
          ),),
      ),
    );
  }
}
