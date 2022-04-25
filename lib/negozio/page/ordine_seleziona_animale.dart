import 'package:flutter/material.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/animale.dart';
import 'package:taass_frontend_android/model/carrello.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/negozio/page/ordine_seleziona_indirizzo.dart';
import 'package:taass_frontend_android/utente/service/utente_service.dart';

class OrdineSelezionaAnimale extends StatefulWidget {
  OrdineSelezionaAnimale(
      {required this.utente, required this.carrello, Key? key})
      : super(key: key);

  Utente utente;
  Carrello carrello;

  @override
  State<StatefulWidget> createState() => _OrdineSelezionaAnimaleState();
}

class _OrdineSelezionaAnimaleState extends State<OrdineSelezionaAnimale> {
  late Future<List<Animale>> animali;
  UtenteService utenteService = UtenteService();

  _OrdineSelezionaAnimaleState();

  @override
  void initState() {
    super.initState();
    animali = utenteService.getUtente(widget.utente).then((u) => u.animali);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleziona animale'),
      ),
      bottomNavigationBar: MyBottomNavBar(utente: widget.utente),
      body: FutureBuilder<List<Animale>>(
        future: animali,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return listaAnimali(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget listaAnimali(List<Animale> animali) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Text(
            'Stai comprando per',
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
              children: animali.map(animaleCard).toList()),
        ),
      ],
    );
  }

  Widget animaleCard(Animale animale) {
    return Card(
        key: UniqueKey(),
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => OrdineSelezionaIndirizzo(
                      utente: widget.utente,
                      carrello: widget.carrello,
                      animale: animale))),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 15.0),
                  child: Image.asset(
                    'assets/images/cat_dogs.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Text(
                  animale.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ));
  }
}
