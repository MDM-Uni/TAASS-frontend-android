import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/animale.dart';
import 'package:intl/intl.dart';
import 'package:taass_frontend_android/model/utente.dart';
import '../service/utente_service.dart';
import 'dashboard.dart';

class DettagliAnimale extends StatefulWidget {
  final Animale animale;
  final bool nuovo;
  late Utente utente;

  DettagliAnimale(this.utente, this.animale, this.nuovo);

  @override
  _DettagliAnimaleState createState() => _DettagliAnimaleState();
}

class _DettagliAnimaleState extends State<DettagliAnimale> {

  final TextEditingController nome = TextEditingController();
  final TextEditingController data = TextEditingController();
  final TextEditingController patologie = TextEditingController();
  final TextEditingController peso = TextEditingController();
  final TextEditingController razza = TextEditingController();
  late bool? peloPungo = this.widget.animale.peloLungo;
  late List<TextEditingController> _patologie = [TextEditingController()];
  late List<String> patologia = [];
  UtenteService httpService = UtenteService();


  @override
  void initState() {
    // TODO: implement initState
    if(!widget.nuovo){
      nome.text = widget.animale.nome;
      data.text = widget.animale.dataDiNascita.toString().substring(0,10);
      if(widget.animale.patologie != null && widget.animale.patologie!.isNotEmpty) {
        _patologie.clear();
        for (var patologia in widget.animale.patologie!){
          final controller = TextEditingController();
          controller.text = patologia;
          _patologie.add(controller);
        }
      }
      razza.text = widget.animale.razza ?? '';
      peso.text = widget.animale.peso.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dettagli Animale"),
      ),
      bottomNavigationBar: MyBottomNavBar(utente: widget.utente),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          late Animale _animale;
          if(widget.nuovo){
            for(var pat in _patologie){
              patologia.add(pat.text);
            }
            _animale = Animale(id: 0, nome: nome.text, dataDiNascita: DateTime.parse(data.text), patologie: patologia, razza: razza.text, peso: num.parse(peso.text), peloLungo: peloPungo);
            widget.utente = await httpService.addAnimal(widget.utente, _animale);
            //Navigator.push(context, new MaterialPageRoute(builder: (__) => new Dashboard(widget.utente)));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Animale aggiunto con successo"),
            ));
            Navigator.pop(context,widget.utente);
          } else {
            for(var pat in _patologie){
              if(pat.text != ""){
                patologia.add(pat.text);
              }
              patologia.add(pat.text);
            }
            _animale = Animale(id: widget.animale.id, nome: nome.text, dataDiNascita: DateTime.parse(data.text), patologie: patologia, razza:razza.text, peso :num.parse(peso.text), peloLungo: peloPungo);
            _animale = await httpService.updateAnimal(widget.utente,widget.animale,_animale);
            widget.utente.animali.remove(widget.animale);
            widget.utente.animali.add(_animale);
            //Navigator.push(context, new MaterialPageRoute(builder: (__) => new Dashboard(widget.utente)));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Animale aggiornato con successo"),
            ));
            Navigator.pop(context,widget.utente);
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Card(
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
                    keyboardType: TextInputType.none,
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _patologie.length,
                  itemBuilder: (context,index){
                    return addPatologia(_patologie[index], "Patologia",index+1);
                  },
                ),
                CasellaTesto(razza, "Razza"),
                Padding(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: peso,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: "Peso",
                      ),
                    ),
                ),
                CheckboxListTile(
                  title: Text("Pelo lungo"),
                  checkColor: Colors.greenAccent,
                  value: this.peloPungo,
                  onChanged: (bool? value){
                    setState(() {
                      this.peloPungo = value!;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  addPatologia(TextEditingController patologie, String s, int index) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
          children: [
            Text('Patologia: $index'),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                autofocus: true,
                textAlign: TextAlign.center,
                controller: patologie,
                decoration: InputDecoration(
                  suffixIcon: Container(
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if(index !=0 && _patologie.length>1)
                            IconButton(onPressed: (){
                              if(_patologie.length>1){
                                setState(() {
                                  _patologie.removeAt(index-1);
                                });
                              }
                              else {patologie.text = "";}
                            }, icon: Icon(Icons.clear)),
                          if(this._patologie.length == index)
                            IconButton(onPressed: (){
                              setState(() {
                                final controller = TextEditingController();
                                _patologie.add(controller);
                              });
                            }, icon: Icon(Icons.add)),
                        ],
                      ),
                    ),
                  )
                ),
              ),
            )
          ]
      ),
    );
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


