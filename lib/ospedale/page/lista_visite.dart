import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:taass_frontend_android/ospedale/model/animale.dart';
import 'package:taass_frontend_android/ospedale/model/utente.dart';
import 'package:taass_frontend_android/ospedale/model/visita.dart';
import 'package:taass_frontend_android/ospedale/service/visite_service.dart';

class ListaVisite extends StatefulWidget {
  ListaVisite({Key? key}) : super(key: key);
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
  State<StatefulWidget> createState() => _ListaVisiteState(utente);
}

class _ListaVisiteState extends State<ListaVisite> {
  late Future<List<Visita>> visite;
  Utente utente;

  _ListaVisiteState(this.utente);

  @override
  void initState() {
    super.initState();
    visite = VisiteService.getVisite(utente.animali, null, null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Visita>>(
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
            visitaField('🆔', 'Id', visita.id.toString()),
            visitaField('🗓', 'Data', DateFormat('dd/MM/yyyy HH:mm').format(visita.data)),
            visitaField(' ', 'Durata', visita.durataInMinuti.toString()),
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
    res.then((successo) => {
      if (successo) {
        setState(() {
          visite = visite.then((visite_) =>
            visite_.where((visita) => visita != visitaDaEliminare).toList());
        })
      }
    });
  }
}
