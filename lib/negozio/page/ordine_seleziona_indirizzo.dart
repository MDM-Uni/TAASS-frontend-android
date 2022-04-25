import 'package:flutter/material.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/animale.dart';
import 'package:taass_frontend_android/model/carrello.dart';
import 'package:taass_frontend_android/model/indirizzo.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/negozio/page/ordine_riepilogo.dart';
import 'package:taass_frontend_android/negozio/service/indirizzi_service.dart';

class OrdineSelezionaIndirizzo extends StatefulWidget {
  OrdineSelezionaIndirizzo(
      {required this.utente,
      required this.carrello,
      required this.animale,
      Key? key})
      : super(key: key);

  Utente utente;
  Carrello carrello;
  Animale animale;

  @override
  State<StatefulWidget> createState() => _OrdineSelezionaIndirizzoState();
}

class _OrdineSelezionaIndirizzoState extends State<OrdineSelezionaIndirizzo> {
  late Future<List<Indirizzo>> indirizzi;
  late Indirizzo? indirizzoSelezionato;

  _OrdineSelezionaIndirizzoState();

  @override
  void initState() {
    super.initState();
    indirizzi = IndirizziService.getIndirizzi(widget.utente.id);
    indirizzi.then((i) => indirizzoSelezionato = i.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleziona indirizzo'),
      ),
      bottomNavigationBar: MyBottomNavBar(utente: widget.utente),
      body: FutureBuilder<List<Indirizzo>>(
        future: indirizzi,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            indirizzoSelezionato = snapshot.data!.first;
            return listaIndirizzi(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget listaIndirizzi(List<Indirizzo> indirizzi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Text(
            'Scegli un indirizzo di consegna',
            style: TextStyle(fontSize: 17),
          ),
        ),
        Flexible(
          // fondamentale per riempire la column
          child: GridView.count(
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              padding: const EdgeInsets.all(8),
              crossAxisCount: 2,
              children: indirizzi.map(indirizzoCard).toList()),
        ),
      ],
    );
  }

  Widget indirizzoCard(Indirizzo indirizzo) {
    return Card(
        key: UniqueKey(),
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OrdineRiepilogo(
                      utente: widget.utente,
                      carrello: widget.carrello,
                      animale: widget.animale,
                      indirizzo: indirizzo))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15.0),
                    child: Image.asset(
                      'assets/images/indirizzo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Text(
                  indirizzo.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ));
  }
}
