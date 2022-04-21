import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:taass_frontend_android/ospedale/model/animale.dart';
import 'package:taass_frontend_android/ospedale/model/utente.dart';
import 'package:taass_frontend_android/model/visita.dart';
import 'package:taass_frontend_android/ospedale/service/visite_service.dart';

class AggiuntaVisitaForm extends StatefulWidget {
  AggiuntaVisitaForm({Key? key}) : super(key: key);
  final Utente utente = Utente(
      1,
      'marcoscale98@gmail.com',
      'Marco Scale',
      List.of([
        Animale(id: 2, nome: 'Leo'),
        Animale(id: 3, nome: 'Pippo'),
        Animale(id: 5, nome: 'oiohui'),
      ]));

  @override
  State<AggiuntaVisitaForm> createState() {
    return _AggiuntaVisitaFormState(utente);
  }
}

class _AggiuntaVisitaFormState extends State<AggiuntaVisitaForm> {
  final _formKey = GlobalKey<FormState>();
  late Visita visita;
  Utente utente;
  var dataController = TextEditingController();

  _AggiuntaVisitaFormState(this.utente) {
    visita = Visita(
      animale: utente.animali[0],
      data: DateTime.now().add(const Duration(days: 1)),
      tipoVisita: TipoVisita.VACCINO,
      durataInMinuti: 30,
    );
    dataController.text = DateFormat('dd/MM/yyyy HH:mm').format(visita.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiunta visite'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              //scelta animale
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildSceltaAnimaleInputWidget(),
              ),
              //scelta data e ora
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildDataOraInputWidget(context)),
              //scelta tipoVisita
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildSceltaTipoVisitaInputWidget(),
              ),
              //durata
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildDurataInputWidget(),
              ),
              //note
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration.collapsed(hintText: 'Note'),
                  initialValue: '',
                  onChanged: (newValue) {
                    if (newValue != null && newValue != '') {
                      setState(() {
                        visita.note = newValue;
                      });
                    }
                  },
                ),
              ),
              //bottone prenotazione
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () => prenotaVisita(),
                  child: const Text('Prenota'),
                ),
              ),
            ],
          )),
    );
  }

  Row buildDurataInputWidget() {
    return Row(
      children: [
        const Expanded(
          flex: 3,
          child: Text('Durata'),
        ),
        Expanded(
          flex: 7,
          child: SpinBox(
            min: 1,
            max: 180,
            value: visita.durataInMinuti.toDouble(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              //log('durata settata a $value');
              setState(() {
                visita.durataInMinuti = value.toInt();
              });
            },
            validator: (newValue) {
              if (newValue == null) {
                return "Inserire una durata della visita valida (compresa tra 1 minuto e 180 minuti)";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  DropdownButtonFormField<TipoVisita> buildSceltaTipoVisitaInputWidget() {
    return DropdownButtonFormField(
      hint: Text("Tipo visita"),
      items: [
        for (var tipo in TipoVisita.values)
          DropdownMenuItem<TipoVisita>(
            child: Text(Visita.tipoVisitaToString(tipo)),
            value: tipo,
          )
      ],
      onTap: () {},
      onChanged: (value) {
        if (value != null) {
          setState(() {
            visita.tipoVisita = value;
          });
        }
      },
      validator: (newValue) {
        if (newValue == null || newValue == '') {
          return 'Selezionare il tipo della visita';
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<Animale> buildSceltaAnimaleInputWidget() {
    return DropdownButtonFormField(
      hint: const Text("Animale"),
      value: visita.animale,
      items: [
        for (var animale in utente.animali)
          DropdownMenuItem<Animale>(
            child: Text(animale.nome),
            value: animale,
          )
      ],
      onTap: () {},
      onChanged: (newValue) {
        setState() {
          if (newValue != null) {
            visita.animale = newValue;
          }
        }
      },
      validator: (value) {
        if (value == null || value == 0) {
          return "Selezionare un animale";
        }
        return null;
      },
    );
  }

  Row buildDataOraInputWidget(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            flex: 10,
            child: Text(
              "Data e ora",
            )),
        Expanded(
          flex: 10,
          child: TextFormField(
            controller: dataController,
            decoration: const InputDecoration.collapsed(
                hintText: 'Seleziona data e ora'),
            onTap: () {
              selezionaData(context);
            },
            keyboardType: TextInputType.none,
            validator: (value) {
              if (value == null) {
                return "Selezionare una data e ora";
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  void selezionaData(BuildContext context) {
    Future<DateTime?> dataScelta = DatePicker.showDateTimePicker(context,
        minTime: DateTime.now(),
        maxTime: DateTime.now().add(const Duration(days: 400)),
        currentTime: DateTime.now(),
        locale: LocaleType.it,
        theme: const DatePickerTheme(), onConfirm: (data) {
      log('Selezionata la data $data');
    });
    dataScelta.then((date) {
      if (date != null) {
        dataController.text = DateFormat('dd/MM/yyyy HH:mm').format(date);
        setState(() {
          visita.data = date;
        });
      }
    });
  }

  prenotaVisita() {
    if (_formKey.currentState!.validate()) {
      Future<int?> res = VisiteService.postVisita(visita);
      res.then((id) {
        if (id != null) {
          //visualizzo a schermo una snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visita aggiunta')),
          );
          visita.id = id;
          Navigator.pop(context, visita);
        }
      });
    }
  }
}
