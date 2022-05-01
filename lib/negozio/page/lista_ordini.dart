import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/animale.dart';
import 'package:taass_frontend_android/model/ordine.dart';
import 'package:taass_frontend_android/model/prodotto.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/negozio/service/ordini_service.dart';
import 'package:taass_frontend_android/negozio/service/prodotti_service.dart';
import 'package:taass_frontend_android/utente/service/utente_service.dart';

class ListaOrdini extends StatefulWidget {
  ListaOrdini({required this.utente, Key? key}) : super(key: key);

  Utente utente;

  @override
  State<StatefulWidget> createState() => _ListaOrdiniState();
}

class _ListaOrdiniState extends State<ListaOrdini> {
  late Future<List<AnimaleOrdine>> ordini;
  late DateFormat df;

  _ListaOrdiniState();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('it')
        .then((value) => df = DateFormat('EEEE dd/MM/yyyy', 'it'));
    ordini = OrdiniService.getOrdini(widget.utente.id).then(
        (ordlist) => UtenteService().getUtente(widget.utente).then((utente) {
              for (var i = 0; i < ordlist.length; i++) {
                for (Animale animale in utente.animali) {
                  if (animale.id == ordlist[i].animale.id) {
                    ordlist[i].animale = animale;
                  }
                }
              }
              return ordlist;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordini'),
      ),
      bottomNavigationBar: MyBottomNavBar(utente: widget.utente),
      body: FutureBuilder<List<AnimaleOrdine>>(
        future: ordini,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                padding: const EdgeInsets.all(8),
                children: snapshot.data!.map(ordineCard).toList());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget ordineCard(AnimaleOrdine animOrd) {
    List<Widget> columnItems = [
      Row(
        children: [
          const Text(
            'Ordine ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5),
            child: Row(
              children: [
                Text(
                    '${animOrd.ordine.numeroArticoli} articol${animOrd.ordine.numeroArticoli > 0 ? "i" : "o"}'),
                const Text(', totale'),
                Text(
                  ' € ${animOrd.ordine.totale}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
      Row(
        children: [
          const Text(
            'Acquistato per: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(animOrd.animale.nome)
        ],
      ),
      Row(
        children: [
          const Text(
            'Data di acquisto: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(df.format(animOrd.ordine.dataAcquisto))
        ],
      ),
      Row(
        children: [
          const Text(
            'Indirizzo di consegna: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(animOrd.ordine.indirizzoConsegna.toString())
        ],
      ),
      Row(
        children: [
          const Text(
            'Consegnato: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(animOrd.ordine.dataConsegna != null
              ? df.format(animOrd.ordine.dataConsegna!)
              : 'No')
        ],
      ),
    ];
    columnItems.addAll(animOrd.ordine.prodotti.map(prodottoWidget));
    return Card(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnItems
            .map((e) => Padding(
                  child: e,
                  padding: const EdgeInsets.only(top: 10),
                ))
            .toList(),
      ),
    ));
  }

  Widget prodottoWidget(ProdottoQuantita prodQuant) {
    return Column(
      children: [
        const Divider(),
        const Padding(padding: EdgeInsets.only(top: 5)),
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.network(
                  ProdottiService.getUrlImmagineProdotto(prodQuant.prodotto.id),
                  height: 50,
                  width: 50,
                )),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  prodQuant.prodotto.nome,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(prodQuant.prodotto.categoria),
              ),
              Text(
                '€ ${prodQuant.prodotto.prezzo.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ]),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Row(
                children: [
                  const Text('Quantità: '),
                  Text(
                    prodQuant.quantita.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
