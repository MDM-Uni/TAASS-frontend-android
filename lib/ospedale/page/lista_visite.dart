import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/animale.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/model/visita.dart';
import 'package:taass_frontend_android/ospedale/service/visite_service.dart';

import 'aggiunta_visita_form.dart';

class ListaVisite extends StatefulWidget {
  ListaVisite(this.utente, {Key? key}) : super(key: key);

  // final Utente utente = Utente(
  //     1,
  //     'marcoscale98@gmail.com',
  //     'Marco Scale',
  //     List.of([
  //       Animale(id: 2, nome: 'Leo'),
  //       Animale(id: 3, nome: 'Pippo'),
  //       Animale(id: 5, nome: 'oiohui'),
  //     ]));
  Utente utente;

  @override
  State<StatefulWidget> createState() => _ListaVisiteState();
}

class _ListaVisiteState extends State<ListaVisite> {
  late Future<List<Visita>> visite;
  Animale? animaleFiltrato;
  TipoVisita? tipoVisitaFiltrato;
  final _formKey = GlobalKey<FormState>();

  _ListaVisiteState();

  @override
  void initState() {
    super.initState();
    visite = VisiteService.getVisite(widget.utente.animali, null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista visite'),
      ),
      bottomNavigationBar: MyBottomNavBar(utente: widget.utente),
      body: Column(
        children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              //scelta animale
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildSceltaAnimaleInputWidget(),
              ),
              //scelta tipoVisita
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildSceltaTipoVisitaInputWidget(),
              ),
              //bottone prenotazione
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      visite = VisiteService.getVisite(widget.utente.animali,
                          animaleFiltrato?.id, tipoVisitaFiltrato);
                    });
                  },
                  child: const Text('Filtra'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Visita>>(
            future: visite,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                    padding: const EdgeInsets.all(8),
                    children: snapshot.data!.map(visiteCard).toList());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Future<Visita?> visitaAggiunta = Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AggiuntaVisitaForm(widget.utente)));
          visitaAggiunta.then((visitaAggiunta_) {
            if (visitaAggiunta_ != null) {
              setState(() {
                visite = visite.then((visite_) {
                  visite_.add(visitaAggiunta_);
                  //rimetto in ordine le visite
                  visite_.sort((v1, v2) => v2.data.compareTo(v1.data));
                  return visite_;
                }).then((visite_) {
                  //log(visite_.toString());
                  return visite_;
                });
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Non puoi aggiungere una nuova visita se non aggiungi prima un tuo animale')),
              );
            }
          });
        },
      ),
    );
  }

  Card visiteCard(Visita visita) {
    return Card(
      child: ExpansionTile(
          title: Text(
              ' ${Visita.tipoVisitaToString(visita.tipoVisita)} per ${visita
                  .animale.nome}'),
          children: <Widget>[
            const Divider(),
            visitaField('🗓', 'Data',
                DateFormat('dd/MM/yyyy HH:mm').format(visita.data)),
            visitaField(' ', 'Durata', visita.durataInMinuti.toString()),
            visitaField(' ', 'Tipo Visita',
                Visita.tipoVisitaToString(visita.tipoVisita)),
            if (visita.note != null) visitaField('📒', 'Note', visita.note!),
            const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 7))
          ],
          trailing: IconButton(
              onPressed: () => eliminaVisita(visita),
              icon: const Icon(Icons.delete))),
    );
  }

  Widget visitaField(String? emoji, String name, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 2, 40, 0),
          child: Row(children: [
            Expanded(flex: 4, child: Html(data: '<strong>$name</strong>:')),
            Expanded(
                flex: 10,
                child: Html(data: emoji != null ? '$emoji $value' : '  $value'))
          ])),
    );
  }

  eliminaVisita(Visita visitaDaEliminare) {
    Future<bool> res = VisiteService.deleteVisita(visitaDaEliminare);
    res.then((successo) =>
    {
      if (successo)
        {
          setState(() {
            visite = visite.then((visite_) =>
                visite_
                    .where((visita) => visita != visitaDaEliminare)
                    .toList());
          })
        }
    });
  }

  DropdownButtonFormField<TipoVisita> buildSceltaTipoVisitaInputWidget() {
    return DropdownButtonFormField(
      hint: const Text("Tipo visita"),
      value: tipoVisitaFiltrato,
      items: [
        const DropdownMenuItem(child: Text("Tutti"), value: null),
        for (var tipo in TipoVisita.values)
          DropdownMenuItem<TipoVisita>(
            child: Text(Visita.tipoVisitaToString(tipo)),
            value: tipo,
          )
      ],
      onTap: () {},
      onChanged: (value) {
        setState(() {
            tipoVisitaFiltrato = value;
        });
      },
    );
  }

  DropdownButtonFormField<Animale> buildSceltaAnimaleInputWidget() {
    return DropdownButtonFormField(
      hint: const Text("Animale"),
      items: [
        DropdownMenuItem<Animale>(
          child: const Text("Tutti"),
          value: Animale(id: 0, nome: "Tutti"),
        ),
        for (var animale in widget.utente.animali)
          DropdownMenuItem<Animale>(
            child: Text(animale.nome),
            value: animale,
          )
      ],
      onTap: () {},
      onChanged: (Animale? newValue) {
        setState(() {
            animaleFiltrato = newValue;
          });
      },
    );
  }
}
