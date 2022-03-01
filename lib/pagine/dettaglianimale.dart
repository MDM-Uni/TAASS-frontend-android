import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taass_frontend_android/model/Animale.dart';
import 'package:intl/intl.dart';

class DettagliAnimale extends StatefulWidget {
  const DettagliAnimale({Key? key}) : super(key: key);

  @override
  _DettagliAnimaleState createState() => _DettagliAnimaleState();
}

class _DettagliAnimaleState extends State<DettagliAnimale> {

  final TextEditingController nome = TextEditingController();
  final TextEditingController data = TextEditingController();
  final TextEditingController patologie = TextEditingController();
  final TextEditingController peso = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dettagli Animale"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: aggiornaAnimale,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CasellaTesto(nome, "Nome"),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: data,
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                  labelText: "Data"
                ),
                readOnly: false,
                onTap: () async {
                  DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101));
                  if(date!=null){
                    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                    setState(() {
                      data.text = formattedDate;
                    });
                  }
                },
              ),
            ),
            CasellaTesto(patologie, "Patologie"),
            CasellaTesto(peso, "Peso"),
            CheckboxListTile(
              title: Text("Pelo lungo"),
              checkColor: Colors.greenAccent,
              value: true,
                onChanged: (newValue) { },
            )
          ],
        ),
      ),
    );
  }

  Future aggiornaAnimale() async{
  }

}

class CasellaTesto extends StatelessWidget {
  final TextEditingController controller;
  final String titolo;
  CasellaTesto(this.controller,this.titolo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: titolo,
        ),
      ),
    );
  }
}

