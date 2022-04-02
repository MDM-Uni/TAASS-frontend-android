import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:taass_frontend_android/ospedale/model/utente.dart';
import 'package:taass_frontend_android/ospedale/model/visita.dart';
import 'package:taass_frontend_android/ospedale/service/visite_service.dart';

class ListaVisite extends StatefulWidget {

  const ListaVisite({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListaVisiteState();

}

class _ListaVisiteState extends State<ListaVisite> {
  late Future<List<Visita>> visite;

  _ListaVisiteState();

  @override
  void initState() {
    super.initState();
    visite = VisiteService.getVisite();
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
            visitaField('🗓', 'Data', visita.data.toString()),
            visitaField(' ', 'Durata', visita.durataInMinuti.toString()),
            if (visita.note!=null) visitaField('📒', 'Note', visita.note!),
            const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 7))
          ]),
    );
  }

  Widget visitaField(String? emoji, String name, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 2, 40, 0),
          child: Row(children: [
            Expanded(flex: 4, child: Html(data: '<strong>$name</strong>:')),
            Expanded(flex: 10,
                child: Html(
                    data: emoji != null ? '$emoji $value' : '  $value'))
          ])),
    );
  }
}